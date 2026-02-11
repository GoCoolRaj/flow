import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/app/router/router_manager.dart';
import 'package:quilt_flow_app/domain/home/model/content_flavours.dart';
import 'package:quilt_flow_app/domain/home/model/feed_like_request.dart';
import 'package:quilt_flow_app/domain/home/model/feed_like_response.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_request.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/domain/home/model/home_media.dart';
import 'package:quilt_flow_app/presentation/components/cache_manager/profile_cache_manager.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_event.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_state.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';
import 'package:quilt_flow_app/presentation/home/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

abstract class FeedBloc extends BaseBloc<FeedEvent, FeedState> {
  final String userId;
  VoidCallback? _videoListener;
  bool _isVideoListenerInitialized = false;
  late final _favoriteBloc = GetIt.I<FavoritesBloc>();

  late final _profileCacheManager = GetIt.I<ProfileCacheManager>();

  late final _dio = GetIt.I.get<Dio>();
  final int preLoadFeedItems = 10;
  final int loadBufferFeedItems = 5;
  final int maxMediaMapSize = 7;
  final int loadBufferMediaMapForward = 4;
  final int loadBufferMediaMapBackward = 3;
  double audioPlayerVolume = 0.5;
  int feedScroll = 1;

  FeedBloc({required this.userId}) : super(FeedState(userId: userId)) {
    on<HomeFeedInit>(_onHomeFeedInit);
    on<HomeFeedsRequested>(_onHomeFeedsRequested);
    on<HomeFeedLoadMoreRequested>(_onHomeFeedLoadMoreRequested);
    on<HomeFeedInitializeControllers>(_onHomeFeedInitializeControllers);
    on<FeedClearControllers>(_onFeedClearControllers);
    on<UpdateIndexToPlay>(_onUpdateIndexToPlay);
    on<PlayFirstVideo>(_onPlayFirstVideo);
    on<HomeFeedPageChanged>(_onHomeFeedPageChanged);
    on<HomeFeedPaused>(_onHomeFeedPaused);
    on<HomeFeedResumed>(_onHomeFeedResumed);
    on<HomeFeedMutePressed>(_onHomeFeedMutePressed);
    on<HomeFeedFavoritePressed>(_onHomeFeedFavoritePressed);
    on<UpdateContentCollectionDetails>(_onUpdateContentCollectionDetails);
    on<HomeFeedShowCollectionUI>(_onHomeFeedShowCollectionUI);
    on<UpdateContentItems>(_onUpdateContentItems);

    on<OpenFeedbackDialog>(_openFeedBackDialog);
    on<HomeFeedLikePressed>(_onHomeFeedLikePressed);
    on<HomeFeedDislikePressed>(_onHomeFeedDislikePressed);

    on<UpdateCommentCount>(_onUpdateCommentCount);
  }

  Future<void> _onHomeFeedInit(
    HomeFeedInit event,
    Emitter<FeedState> emit,
  ) async {
    await _profileCacheManager.clearCache();
    final oldMediaMap = state.mediaMap;

    emit(
      FeedState(
        userId: userId,
        feedScope: event.feedScope,
        isCurrentUser: state.isCurrentUser,
        fabricId: event.fabricId ?? "",
        page: event.pageNumber ?? 1,
        playAtIndex: event.playIndex ?? 0,
      ),
    );
    for (var entry in oldMediaMap.entries) {
      await _disposeMedia(entry.value);
    }

    add(
      HomeFeedsRequested(
        pageNumber: event.pageNumber,
        playIndex: event.playIndex,
      ),
    );
  }

  Future<void> _onHomeFeedsRequested(
    HomeFeedsRequested event,
    Emitter<FeedState> emit,
  ) async {
    final feedsRequest = FeedsRequest(
      userId: userId,
      page: event.pageNumber ?? state.page,
      pageSize: 10,
      fabricId: state.feedScope == FeedScope.fabricContent
          ? state.fabricId
          : null,
    );
    List<ContentItem> contentItems = await getFeedContents(
      feedsRequest,
      emit,
      state.feedScope != FeedScope.profile &&
          state.feedScope != FeedScope.fabricContent,
      false,
    );
    if (contentItems.isNotEmpty) {
      emit(
        state.copyWith(
          page: state.page,
          contentItems: [...state.contentItems, ...contentItems],
        ),
      );

      add(
        HomeFeedInitializeControllers(
          startIndex: event.playIndex ?? 0,
          endIndex: (event.playIndex ?? 0) + 3,
          fromFirst: false,
        ),
      );
    } else {
      emit(state.copyWith(feedState: HomeFeedState.fetchedNoData));
    }
  }

  Future<List<ContentItem>> getFeedContents(
    FeedsRequest request,
    Emitter<FeedState> emit,
    bool showLoading,
    bool showError,
  ) async {
    emit(state.copyWith(feedState: HomeFeedState.fetchingFeeds));

    final response = await safeExecute<ContentFeedResponse>(
      function: () async {
        final items = await fetchFeeds(request);

        return ContentFeedResponse(data: items, isUserTimeZoneSet: true);
      },
      showLoading: showLoading,
      showError: showError,
    );

    if (response != null) {
      if (response.data.isNotEmpty) {
        emit(state.copyWith(feedState: HomeFeedState.fetchedSuccess));
      } else {
        emit(state.copyWith(feedState: HomeFeedState.fetchingCompleted));
      }

      return response.data;
    } else {
      emit(state.copyWith(feedState: HomeFeedState.fetchingFailed));

      return [];
    }
  }

  Future<List<ContentItem>> fetchFeeds(FeedsRequest request);

  Future<bool> isImageAccessible(String url) async {
    try {
      final response = await _dio.head(
        url,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _preloadProfileImages(String imageUrl) async {
    try {
      final context = GetIt.I<RouterManager>()
          .goRouter
          .routerDelegate
          .navigatorKey
          .currentContext;

      if (context == null || imageUrl.isEmpty) return false;

      // final uri = Uri.tryParse(imageUrl);
      // if (uri == null || uri.host.isEmpty) return false;

      // final accessible = await isImageAccessible(imageUrl);
      // if (!accessible) {
      //   return false;
      // }

      precacheImage(
        CachedNetworkImageProvider(
          imageUrl,
          cacheKey: imageUrl,
          cacheManager: _profileCacheManager.instance,
        ),
        context,
      );

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> initialiseControllers(
    int startIndex,
    int endIndex,
    bool fromFirst,
    Emitter<FeedState> emit,
  ) async {
    Map<int, HomeMedia> mediaMap = {};
    List<Future> futures = [];

    emit(state.copyWith(feedMediaState: HomeFeedMediaState.fetchingMedia));

    for (int i = startIndex; i < endIndex; i++) {
      if (i >= state.contentItems.length ||
          state.mediaMap.containsKey(i) ||
          i < 0) {
        continue;
      }
      final contentItem = state.contentItems[i];
      final contentFormat = contentItem.content.contentFormat;

      HomeMedia homeMedia = HomeMedia(
        contentFormat: contentFormat,
        contentItem: contentItem,
      );
      mediaMap[i] = homeMedia;

      switch (contentFormat) {
        case ContentFormat.VIDEO:
        default:
          _initializeVideoAndAudio(contentItem, homeMedia, futures);
          futures.add(
            _preloadProfileImages(contentItem.content.profilePicture),
          );
          break;
      }
    }

    Map<int, HomeMedia> updatedMediaMap = updateMap(
      fromFirst: fromFirst,
      oldMap: state.mediaMap,
      newMap: mediaMap,
      maxItemInMemory: maxMediaMapSize,
    );

    Future.wait(futures);
    if ((HomeScreen.feedScope == state.feedScope) ||
        state.feedScope == FeedScope.fabricContent ||
        state.feedScope == FeedScope.profile ||
        state.feedScope == FeedScope.search) {
      if (state.playAtIndex != -1) {
        _handlePlayback(mediaMap, state.playAtIndex);
      }
    }

    emit(
      state.copyWith(
        feedMediaState: HomeFeedMediaState.fetchedSuccess,
        mediaMap: updatedMediaMap,
        playingIndex: state.playingIndex == -1 ? 0 : state.playingIndex,
        playAtIndex: -1,
        videoState: HomeVideoState.isPlaying,
      ),
    );
  }

  void _initializeVideoAndAudio(
    ContentItem contentItem,
    HomeMedia homeMedia,
    List<Future> futures,
  ) {
    var videoUrl = contentItem.content.contentUrl;

    VideoPlayerController? videoPlayerController;
    if (videoUrl.isNotEmpty) {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );
      videoPlayerController.setLooping(true);
    }

    homeMedia.videoPlayerController = videoPlayerController;

    if (videoPlayerController != null) {
      futures.add(videoPlayerController.initialize().catchError((error) {}));
    }
  }

  void _handlePlayback(Map<int, HomeMedia> mediaMap, int index) {
    final controller = mediaMap[index]?.videoPlayerController;
    if (controller == null) return;

    if (_isVideoListenerInitialized) return;
    _isVideoListenerInitialized = true;

    _videoListener = () => firstMediaAddListener(index);
    controller.addListener(_videoListener!);
  }

  void firstMediaAddListener(int index) {
    final controller = state.mediaMap[index]?.videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;
    firstMediaRemoveListener(index);

    add(PlayFirstVideo(index: index));

    WakelockPlus.enable();
  }

  void firstMediaRemoveListener(int index) {
    final controller = state.mediaMap[index]?.videoPlayerController;
    if (controller != null && _videoListener != null) {
      controller.removeListener(_videoListener!);
      _videoListener = null;
      _isVideoListenerInitialized = false;
    }
  }

  Map<int, HomeMedia> updateMap({
    required bool fromFirst,
    required Map<int, HomeMedia> oldMap,
    required Map<int, HomeMedia> newMap,
    required int maxItemInMemory,
  }) {
    final mutableOldMap = Map<int, HomeMedia>.from(oldMap);
    final totalItems = mutableOldMap.length + newMap.length;

    if (totalItems > maxItemInMemory) {
      final excessItems = totalItems - maxItemInMemory;

      final keysToRemove =
          (fromFirst
                  ? mutableOldMap.keys.skip(mutableOldMap.length - excessItems)
                  : mutableOldMap.keys.take(excessItems))
              .toList();

      for (var key in keysToRemove) {
        _disposeMedia(mutableOldMap[key]);
        mutableOldMap.remove(key);
      }
    }

    if (fromFirst) {
      newMap.addAll(mutableOldMap);
    } else {
      mutableOldMap.addAll(newMap);
    }
    if (fromFirst) {
      return newMap;
    } else {
      return mutableOldMap;
    }
  }

  Future<void> disposeMediaMapControllers() async {
    for (var entry in state.mediaMap.entries) {
      _disposeMedia(entry.value);
    }
  }

  Future<void> _disposeMedia(HomeMedia? media) async {
    if (media == null) return;
    switch (media.contentFormat) {
      case ContentFormat.VIDEO:
        if (media.videoPlayerController?.value.isPlaying ?? false) {
          media.videoPlayerController?.pause();
        }

        media.videoPlayerController?.dispose();

        break;
      default:
    }
  }

  Future<void> _onHomeFeedLoadMoreRequested(
    HomeFeedLoadMoreRequested event,
    Emitter<FeedState> emit,
  ) async {
    if (state.feedState == HomeFeedState.fetchingFeeds || state.hasReachedEnd) {
      return;
    }
    final feedsRequest = FeedsRequest(
      userId: userId,
      page: state.page + 1,
      pageSize: preLoadFeedItems,
    );
    List<ContentItem> contentItems = await getFeedContents(
      feedsRequest,
      emit,
      false,
      false,
    );
    if (contentItems.isNotEmpty) {
      emit(
        state.copyWith(
          page: state.page + 1,
          contentItems: [...state.contentItems, ...contentItems],
        ),
      );
    } else {
      emit(state.copyWith(hasReachedEnd: true));
    }
  }

  Future<void> _onHomeFeedInitializeControllers(
    HomeFeedInitializeControllers event,
    Emitter<FeedState> emit,
  ) async {
    await initialiseControllers(
      event.startIndex,
      event.endIndex,
      event.fromFirst,
      emit,
    );
  }

  Future<void> _onFeedClearControllers(
    FeedClearControllers event,
    Emitter<FeedState> emit,
  ) async {
    final oldMediaMap = state.mediaMap;
    _videoListener = null;
    _isVideoListenerInitialized = false;
    emit(
      state.copyWith(
        mediaMap: {},
        playFirstVideo: false,
        playAtIndex: -1,
        playingIndex: -1,
      ),
    );
    for (var entry in oldMediaMap.entries) {
      await _disposeMedia(entry.value);
    }
  }

  Future<void> _onUpdateIndexToPlay(
    UpdateIndexToPlay event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(playAtIndex: event.index, playingIndex: event.index));
  }

  Future<void> _onPlayFirstVideo(
    PlayFirstVideo event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(playFirstVideo: true));
    playMediaAtIndex(event.index);
  }

  Future<void> _onHomeFeedPageChanged(
    HomeFeedPageChanged event,
    Emitter<FeedState> emit,
  ) async {
    if (event.index == state.contentItems.length - 1 &&
        state.feedState == HomeFeedState.fetchingFeeds) {
      pauseMediaAtIndex();
      emit(state.copyWith(playingIndex: event.index));
      return;
    }

    pauseMediaAtIndex();
    var newState = state.copyWith(
      isPaused: false,
      videoState: HomeVideoState.isPlaying,
      isUserPaused: false,
      playingIndex: event.index,
    );

    playMediaAtIndex(event.index);

    _maybeInitializeControllers(event.index);

    emit(newState);

    if (event.index >= state.contentItems.length - loadBufferFeedItems) {
      add(const HomeFeedLoadMoreRequested());
    }
  }

  void _maybeInitializeControllers(int index) {
    if (state.mediaMap.entries.isEmpty) return;

    final int contentLength = state.contentItems.length;
    if (contentLength == 0) return;
    if (index >= state.playingIndex) {
      final lastLoaded = state.mediaMap.entries.last;
      final itemsToLoad = (index + loadBufferMediaMapForward) - lastLoaded.key;
      if (itemsToLoad > 0) {
        final startIndex = (lastLoaded.key + 1).clamp(0, contentLength - 1);
        final endIndex = (lastLoaded.key + 1 + itemsToLoad).clamp(
          0,
          contentLength,
        );
        add(
          HomeFeedInitializeControllers(
            startIndex: startIndex,
            endIndex: endIndex,
            fromFirst: false,
          ),
        );
      }
    } else if (index < state.playingIndex) {
      final firstLoaded = state.mediaMap.entries.first;
      final itemsToLoad =
          ((index - loadBufferMediaMapBackward) - firstLoaded.key).abs();
      if (itemsToLoad > 0) {
        final startIndex = (firstLoaded.key - 1).clamp(0, contentLength - 1);
        final endIndex = (firstLoaded.key - 1 + itemsToLoad).clamp(
          0,
          contentLength,
        );
        add(
          HomeFeedInitializeControllers(
            startIndex: startIndex,
            endIndex: endIndex,
            fromFirst: true,
          ),
        );
      }
    }
  }

  Future<void> pauseMediaAtIndex() async {
    final index = state.playingIndex;
    final media = state.mediaMap[index];
    if (media == null) return;
    media.videoPlayerController?.pause();
  }

  Future<void> playMediaAtIndex(int index) async {
    final media = state.mediaMap[index];
    if (media == null) return;
    try {
      _toggleMuteMediaAtIndex(index, state.isMuted);
      media.videoPlayerController?.play();
    } catch (_) {}
  }

  Future<void> _onHomeFeedPaused(
    HomeFeedPaused event,
    Emitter<FeedState> emit,
  ) async {
    final isUserInitiated = event.isUserInitiated ?? false;

    if (state.isUserPaused && !isUserInitiated) {
      return;
    }

    pauseMediaAtIndex();
    WakelockPlus.disable();

    emit(
      state.copyWith(
        isPaused: true,
        isUserPaused: isUserInitiated,
        videoState: HomeVideoState.isPaused,
      ),
    );
  }

  Future<void> _onHomeFeedResumed(
    HomeFeedResumed event,
    Emitter<FeedState> emit,
  ) async {
    final isUserInitiated = event.isUserInitiated ?? false;

    if (state.isUserPaused && !isUserInitiated) {
      return;
    }
    playMediaAtIndex(state.playingIndex);
    WakelockPlus.enable();

    emit(
      state.copyWith(
        isPaused: false,
        isUserPaused: isUserInitiated ? false : state.isUserPaused,
        videoState: HomeVideoState.isPlaying,
      ),
    );
  }

  Future<void> _onHomeFeedMutePressed(
    HomeFeedMutePressed event,
    Emitter<FeedState> emit,
  ) async {
    _toggleMuteMediaAtIndex(state.playingIndex, event.isMuted);
    emit(state.copyWith(isMuted: event.isMuted));
  }

  void _toggleMuteMediaAtIndex(int index, bool mute) {
    final media = state.mediaMap[index];
    if (media == null) return;
    if (mute) {
      media.videoPlayerController?.setVolume(0.0);
    } else {
      media.videoPlayerController?.setVolume(audioPlayerVolume);
    }
  }

  Future<void> _onHomeFeedShowCollectionUI(
    HomeFeedShowCollectionUI event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(showCollectionStatus: event.showCollectionStatus));
  }

  Future<void> _onHomeFeedFavoritePressed(
    HomeFeedFavoritePressed event,
    Emitter<FeedState> emit,
  ) async {
    List<ContentItem> updatedItems = List<ContentItem>.from(state.contentItems);
    final itemIndex = updatedItems.indexWhere(
      (item) => item.content.id == event.id,
    );
    if (itemIndex != -1) {
      ContentItem oldItem = updatedItems[itemIndex];
      final updatedContent = oldItem.content.copyWith(
        isFavourite: event.isFavorite,
      );
      ContentItem updatedItem = oldItem.copyWith(content: updatedContent);
      updatedItems[itemIndex] = updatedItem;
    }
    if (event.isUpdateFavorite ?? true) {
      _favoriteBloc.add(
        UserFavoriteEvent(
          isFavorite: event.isFavorite,
          contentId: event.id,
          feedScope: event.feedScope,
          collectionId: event.collectionId,
          isUpdatedFromFavoriteList: false,
        ),
      );
    }
    emit(state.copyWith(contentItems: updatedItems));
  }

  Future<void> _onUpdateContentCollectionDetails(
    UpdateContentCollectionDetails event,
    Emitter<FeedState> emit,
  ) async {
    List<ContentItem> updatedItems = List<ContentItem>.from(state.contentItems);
    final itemIndex = updatedItems.indexWhere(
      (item) => item.content.id == event.contentId,
    );
    if (itemIndex != -1) {
      ContentItem oldItem = updatedItems[itemIndex];
      Content content = oldItem.content;
      content.copyWith(
        isFavourite: event.isFavorite,
        collectionId: event.collectionId,
      );
      ContentItem updatedItem = oldItem.copyWith(content: content);
      updatedItems[itemIndex] = updatedItem;
      emit(state.copyWith(contentItems: updatedItems));
    }
  }

  Future<void> _onUpdateContentItems(
    UpdateContentItems event,
    Emitter<FeedState> emit,
  ) async {
    List<ContentItem> updatedItems = List<ContentItem>.from(state.contentItems);
    for (final contentId in event.contentIds) {
      final itemIndex = updatedItems.indexWhere(
        (item) => item.content.id == contentId,
      );
      if (itemIndex != -1) {
        ContentItem oldItem = updatedItems[itemIndex];
        Content content = oldItem.content;
        content.copyWith(
          isFavourite: event.isFavorite,
          collectionId: event.collectionId,
        );
        ContentItem updatedItem = oldItem.copyWith(content: content);
        updatedItems[itemIndex] = updatedItem;
      }
    }
    emit(state.copyWith(contentItems: updatedItems));
  }

  Future<void> _openFeedBackDialog(
    OpenFeedbackDialog event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(isOpenedFeedbackDialog: event.isOpened));
  }

  Future<void> _onHomeFeedLikePressed(
    HomeFeedLikePressed event,
    Emitter<FeedState> emit,
  ) async {
    final oldItems = [...state.contentItems];
    final index = oldItems.indexWhere(
      (item) => item.content.id == event.contentId,
    );
    if (index == -1) return;

    final originalItem = oldItems[index];
    final originalLikeCount = originalItem.content.likeCount;

    final updatedItem = originalItem.copyWith(
      content: originalItem.content.copyWith(
        isLike: true,
        likeCount: originalLikeCount + 1,
      ),
    );
    oldItems[index] = updatedItem;
    emit(state.copyWith(contentItems: oldItems));

    final likeRequest = FeedLikeRequest(
      userId: userId,
      contentId: event.contentId,
    );
  }

  Future<void> _onHomeFeedDislikePressed(
    HomeFeedDislikePressed event,
    Emitter<FeedState> emit,
  ) async {
    final oldItems = [...state.contentItems];
    final index = oldItems.indexWhere(
      (item) => item.content.id == event.contentId,
    );
    if (index == -1) return;

    final originalItem = oldItems[index];
    final originalLikeCount = originalItem.content.likeCount;

    final updatedItem = originalItem.copyWith(
      content: originalItem.content.copyWith(
        isLike: false,
        likeCount: (originalLikeCount - 1).clamp(0, double.infinity).toInt(),
      ),
    );
    oldItems[index] = updatedItem;
    emit(state.copyWith(contentItems: oldItems));

    final dislikeRequest = FeedLikeRequest(
      userId: userId,
      contentId: event.contentId,
    );
  }

  Timer? _likeDislikeDebounceTimer;
  Future<void> Function()? _pendingLikeDislikeAction;

  Future<void> _updateLikeDislikeStatus({
    required String contentId,
    required Future<FeedLikeResponse> Function() executeAction,
    required bool isLikeAction,
    required Emitter<FeedState> emit,
  }) async {
    _likeDislikeDebounceTimer?.cancel();
    _pendingLikeDislikeAction = () async {
      final oldItems = [...state.contentItems];
      final index = oldItems.indexWhere((item) => item.content.id == contentId);
      if (index == -1) return;
      final originalItem = oldItems[index];
      final originalLikeCount = originalItem.content.likeCount;
      try {
        final response = await safeExecute<FeedLikeResponse?>(
          function: () async => await executeAction(),
          showLoading: false,
          showError: false,
        );
        if (response == null) {
          final rollbackItem = originalItem.copyWith(
            content: originalItem.content.copyWith(
              likeCount: isLikeAction
                  ? (originalLikeCount - 1).clamp(0, double.infinity).toInt()
                  : (originalLikeCount + 1),
              isLike: !isLikeAction,
            ),
          );
          oldItems[index] = rollbackItem;
          emit(state.copyWith(contentItems: oldItems));
          return;
        }
      } catch (_) {
        final rollbackItem = originalItem.copyWith(
          content: originalItem.content.copyWith(
            likeCount: isLikeAction
                ? (originalLikeCount - 1).clamp(0, double.infinity).toInt()
                : (originalLikeCount + 1),
            isLike: !isLikeAction,
          ),
        );
        oldItems[index] = rollbackItem;
        emit(state.copyWith(contentItems: oldItems));
      }
    };

    _likeDislikeDebounceTimer = Timer(const Duration(milliseconds: 800), () {
      _pendingLikeDislikeAction?.call();
      _pendingLikeDislikeAction = null;
    });
  }

  @override
  Future<void> close() async {
    disposeMediaMapControllers();
    super.close();
  }

  Future<void> _onUpdateCommentCount(
    UpdateCommentCount event,
    Emitter<FeedState> emit,
  ) async {
    final updatedItems = List<ContentItem>.from(state.contentItems);
    final index = updatedItems.indexWhere(
      (item) => item.content.id == event.contentId,
    );
    if (index != -1) {
      final oldItem = updatedItems[index];
      final updatedContent = oldItem.content.copyWith(
        totalComments: event.commentCount,
      );
      updatedItems[index] = oldItem.copyWith(content: updatedContent);
      emit(state.copyWith(contentItems: updatedItems));
    }
  }
}
