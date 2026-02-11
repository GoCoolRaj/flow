import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/domain/home/model/home_media.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_event.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';

enum HomeFeedState {
  initial,
  fetchingFeeds,
  fetchedSuccess,
  fetchedNoData,
  fetchingCompleted,
  fetchingFailed,
}

enum HomeFeedMediaState {
  initial,
  fetchingMedia,
  fetchedSuccess,
  fetchedNoData,
  fetchingFailed,
}

enum HomeVideoState { initial, isPlaying, isPaused, isStopped }

enum DownloadShareStatus { initial, downloading, downloaded, failed }

enum BlockUserState { initial, loading, blockSuccess, blockFailed }

enum DownloadMultipleVideoStatus {
  initial,
  downloadStarted,
  downloading,
  downloaded,
  failed,
}

class FeedState extends Equatable {
  final String userId;
  final FeedScope feedScope;
  final List<ContentItem> contentItems;
  final Map<int, HomeMedia> mediaMap;
  final HomeFeedState feedState;
  final HomeVideoState videoState;
  final BlockUserState blockUserState;
  final HomeFeedMediaState feedMediaState;
  final ShowCollectionStatus showCollectionStatus;
  final int page;
  final int playingIndex;
  final int playAtIndex;
  final bool playFirstVideo;
  final bool isMuted;
  final bool isPaused;
  final bool isUserPaused;
  final DownloadShareStatus downloadShareStatus;
  final DownloadMultipleVideoStatus downloadMultipleVideoStatus;
  final bool isOpenedFeedbackDialog;
  final bool isCurrentUser;
  final String fabricId;
  final Set<ContentItem> selectedContentItems;
  final int downloadedCount;
  final int totalToDownload;
  final bool isDownloadCancelled;
  final bool hasReachedEnd;

  const FeedState({
    required this.userId,
    this.feedScope = FeedScope.forYou,
    this.contentItems = const [],
    this.selectedContentItems = const {},
    this.mediaMap = const {},
    this.feedState = HomeFeedState.initial,
    this.blockUserState = BlockUserState.initial,
    this.videoState = HomeVideoState.initial,
    this.showCollectionStatus = ShowCollectionStatus.unknown,
    this.feedMediaState = HomeFeedMediaState.initial,
    this.page = 1,
    this.playingIndex = 0,
    this.playAtIndex = 0,
    this.playFirstVideo = false,
    this.isMuted = false,
    this.isPaused = false,
    this.isUserPaused = false,
    this.downloadShareStatus = DownloadShareStatus.initial,
    this.downloadMultipleVideoStatus = DownloadMultipleVideoStatus.initial,
    this.isOpenedFeedbackDialog = false,
    this.isCurrentUser = false,
    this.fabricId = "",
    this.downloadedCount = 0,
    this.totalToDownload = 0,
    this.isDownloadCancelled = false,
    this.hasReachedEnd = false,
  });

  FeedState copyWith({
    String? userId,
    FeedScope? feedScope,
    String? mood,
    String? hashtag,
    List<ContentItem>? contentItems,
    Map<int, HomeMedia>? mediaMap,
    HomeFeedState? feedState,
    BlockUserState? blockUserState,
    HomeVideoState? videoState,
    ShowCollectionStatus? showCollectionStatus,
    HomeFeedMediaState? feedMediaState,
    int? page,
    int? playingIndex,
    int? playAtIndex,
    bool? playFirstVideo,
    bool? isMuted,
    bool? isPaused,
    bool? isUserPaused,
    bool? isSeekbarDragging,
    DownloadShareStatus? downloadShareStatus,
    DownloadMultipleVideoStatus? downloadMultipleVideoStatus,
    bool? isOpenedFeedbackDialog,
    bool? isCurrentUser,
    String? fabricId,
    Set<ContentItem>? selectedContentItems,
    int? downloadedCount,
    int? totalToDownload,
    bool? isDownloadCancelled,
    bool? hasReachedEnd,
  }) {
    return FeedState(
      userId: userId ?? this.userId,
      feedScope: feedScope ?? this.feedScope,
      contentItems: contentItems ?? this.contentItems,
      mediaMap: mediaMap ?? this.mediaMap,
      feedState: feedState ?? this.feedState,
      videoState: videoState ?? this.videoState,
      feedMediaState: feedMediaState ?? this.feedMediaState,
      showCollectionStatus: showCollectionStatus ?? this.showCollectionStatus,
      page: page ?? this.page,
      playingIndex: playingIndex ?? this.playingIndex,
      playAtIndex: playAtIndex ?? this.playAtIndex,
      playFirstVideo: playFirstVideo ?? this.playFirstVideo,
      isMuted: isMuted ?? this.isMuted,
      isPaused: isPaused ?? this.isPaused,
      isUserPaused: isUserPaused ?? this.isUserPaused,
      blockUserState: blockUserState ?? this.blockUserState,
      downloadShareStatus: downloadShareStatus ?? this.downloadShareStatus,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      fabricId: fabricId ?? this.fabricId,
      isOpenedFeedbackDialog:
          isOpenedFeedbackDialog ?? this.isOpenedFeedbackDialog,
      selectedContentItems: selectedContentItems ?? this.selectedContentItems,
      downloadedCount: downloadedCount ?? this.downloadedCount,
      totalToDownload: totalToDownload ?? this.totalToDownload,
      downloadMultipleVideoStatus:
          downloadMultipleVideoStatus ?? this.downloadMultipleVideoStatus,
      isDownloadCancelled: isDownloadCancelled ?? this.isDownloadCancelled,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    feedScope,
    contentItems,
    mediaMap,
    feedState,
    videoState,
    feedMediaState,
    showCollectionStatus,
    page,
    playingIndex,
    playAtIndex,
    playFirstVideo,
    isMuted,
    isPaused,
    isUserPaused,
    downloadShareStatus,
    isOpenedFeedbackDialog,
    blockUserState,
    isCurrentUser,
    fabricId,
    selectedContentItems,
    downloadedCount,
    totalToDownload,
    downloadMultipleVideoStatus,
    isDownloadCancelled,
    hasReachedEnd,
  ];
}
