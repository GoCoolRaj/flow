import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/app/helpers/quilt_snack_bar_manager.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/domain/create_profile/model/create_profile_response.dart';
import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';
import 'package:quilt_flow_app/domain/favorites/model/create_collection_response.dart';
import 'package:quilt_flow_app/domain/favorites/model/delete_collection_response.dart';
import 'package:quilt_flow_app/domain/favorites/model/favorite_list_object.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/create_collection_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/delete_collection_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/favorite_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/get_collection_list_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/get_favorites_list_use_cases.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_state.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_event.dart';
import 'package:quilt_flow_app/presentation/home/bloc/for_you_bloc.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';

class FavoritesBloc extends BaseBloc<FavoritesEvent, FavoritesState> {
  late final String userId;
  late final String generatedUserId;
  late final _hiveManager = getIt.get<HiveManager>();
  late final _createCollectionUseCases = getIt.get<CreateCollectionUseCases>();
  late final _favoriteUseCases = getIt.get<FavoriteUseCases>();
  late final _deleteCollectionUseCases = getIt.get<DeleteCollectionUseCases>();
  late final _getFavoriteListUseCases = getIt.get<GetFavoritesListUseCases>();
  late final _getCollectionListUseCases = getIt
      .get<GetCollectionListUseCases>();
  final int pageLimit = 10;
  final String defaultLibraryName = "Your library";

  late final _forYouBloc = GetIt.I.get<ForYouBloc>();

  FavoritesBloc({required this.userId}) : super(const FavoritesState()) {
    on<ToggleCreateView>(_onToggleCreateView);
    on<ToggleUpdateView>(_onToggleUpdateView);
    on<ToggleNewCollectionCreateView>(_onToggleNewCollectionCreateView);
    on<CollectionNameChanged>(_onCollectionNameChanged);
    on<CreateCollection>(_onCreateCollection);
    on<GetCollections>(_onGetCollectionList);
    on<GetFavoriteCollectionsCount>(_onGetFavoriteCollectionCountList);
    on<DeleteCollection>(_onDeleteCollection);
    on<UpdateCollection>(_onUpdateCollection);
    on<ToggleFavorite>(_onToggleFavorite);
    on<InitFavorite>(_onInitFavorite);
    on<GetFavoriteList>(_onGetFavoriteList);
    on<UserFavoriteEvent>(_onFavoriteContent);
    _initializeDefaultLibrary();
  }
  void _initializeDefaultLibrary() {
    add(GetCollections());
  }

  void _onInitFavorite(InitFavorite event, Emitter<FavoritesState> emit) {
    emit(
      state.copyWith(
        createCollectionStatus: CreateCollectionStatus.unknown,
        isCreateView: false,
        isUpdateView: false,
        isNewCollectionCreateView: false,
      ),
    );
  }

  void _onToggleCreateView(
    ToggleCreateView event,
    Emitter<FavoritesState> emit,
  ) {
    emit(
      state.copyWith(
        isCreateView: event.show,
        isUpdateView: false,
        isNewCollectionCreateView: false,
      ),
    );
  }

  void _onToggleNewCollectionCreateView(
    ToggleNewCollectionCreateView event,
    Emitter<FavoritesState> emit,
  ) {
    emit(
      state.copyWith(
        isCreateView: false,
        isUpdateView: false,
        isNewCollectionCreateView: true,
        isCreateCollectionEnabled: false,
        collectionName: "",
      ),
    );
  }

  void _onToggleUpdateView(
    ToggleUpdateView event,
    Emitter<FavoritesState> emit,
  ) {
    emit(
      state.copyWith(
        isCreateView: false,
        isUpdateView: true,
        isNewCollectionCreateView: false,
      ),
    );
  }

  void _onCollectionNameChanged(
    CollectionNameChanged event,
    Emitter<FavoritesState> emit,
  ) {
    if (event.collectionName.isNotEmpty) {
      emit(
        state.copyWith(
          collectionName: event.collectionName,
          isCreateCollectionEnabled: true,
        ),
      );
      return;
    }
    emit(state.copyWith(collectionName: "", isCreateCollectionEnabled: false));
  }

  Future<void> _onGetCollectionList(
    GetCollections event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final response = await getCollectionListApi();
      if (response != null && response.isNotEmpty) {
        final existingCollections = _hiveManager.getCollectionsList();
        final existingById = <String, CollectionObject>{
          for (var existing
              in existingCollections.whereType<CollectionObject>())
            if (existing.collectionId != null) existing.collectionId!: existing,
        };
        if (existingCollections.isEmpty) {
          response[0].isFavorite = true;
        }
        final responseCollectionIds = response
            .map((c) => c.collectionId)
            .whereType<String>()
            .toSet();
        for (var existingId in existingById.keys) {
          if (!responseCollectionIds.contains(existingId)) {
            await _hiveManager.deleteCollection(existingId);
          }
        }
        for (var collection in response) {
          final existing = existingById[collection.collectionId];
          if (existing != null) {
            collection.isFavorite = existing.isFavorite;
            collection.collectionCount = existing.collectionCount;
          }
        }
        await _hiveManager.storeCollectionsBatch(response);
        emit(state.copyWith(collections: _hiveManager.getCollectionsList()));
      } else {
        if (_hiveManager.getCollectionsList().isEmpty) {
          add(
            CreateCollection(
              collectionName: defaultLibraryName,
              isFavorite: false,
            ),
          );
        }
      }
    } catch (e) {
      //Error
    }
  }

  Future<List<CollectionObject>?> getCollectionListApi() async {
    final response = await safeExecute<List<CollectionObject>>(
      function: () async {
        return await _getCollectionListUseCases.execute(
          request: _hiveManager.getFromHive(HiveManager.userIdKey)!,
        );
      },
      showLoading: false,
      showError: false,
    );
    return response;
  }

  Future<void> _onGetFavoriteCollectionCountList(
    GetFavoriteCollectionsCount event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final response = await getCollectionListApi();
      if (response != null && response.isNotEmpty) {
        await _hiveManager.updateCollectionFavoriteCount(response);
      } else {
        await _hiveManager.updateCollectionFavoriteCount([]);
      }
      emit(state.copyWith(collections: _hiveManager.getCollectionsList()));
    } catch (e) {
      //Error
    }
  }

  Future<CreateProfileResponse?> favoriteApiRequest(
    String collectionId,
    String contentId,
    bool isFavourite,
    bool isShowLoading,
  ) async {
    if (collectionId.trim().isEmpty || contentId.trim().isEmpty) {
      await showErrorMsg('Missing content or collection.');
      return null;
    }
    return await safeExecute<CreateProfileResponse>(
      function: () async {
        return await _favoriteUseCases.execute(
          request: FavoriteRequest(
            userId: _hiveManager.getFromHive(HiveManager.userIdKey)!,
            contentId: contentId,
            collectionId: collectionId,
            isFavourite: isFavourite,
          ),
        );
      },
      showLoading: isShowLoading,
      showError: false,
    );
  }

  Future<void> _onCreateCollection(
    CreateCollection event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          createCollectionStatus: CreateCollectionStatus.sendingRequest,
        ),
      );
      final response = await safeExecute<CreateCollectionResponse>(
        function: () async {
          return await _createCollectionUseCases.execute(
            request: CreateCollectionRequest(
              userId: _hiveManager.getFromHive(HiveManager.userIdKey)!,
              collectionName: event.collectionName!,
              collectionId: '',
            ),
          );
        },
        showLoading: true,
        showError: false,
      );

      if (response != null && response.statusCode == 0) {
        final favoriteCollection = _getFavoriteCollectionOrNull();
        _hiveManager.storeCollectionDetails(
          CollectionObject(
            collectionId: response.collectionId,
            collectionName: response.collectionName,
            isFavorite: true,
          ),
        );
        emit(
          state.copyWith(
            createCollectionStatus:
                CreateCollectionStatus.createCollectionSuccess,
            collections: _hiveManager.getCollectionsList(),
          ),
        );
        var updatedCollections = updateFavoriteSelection(
          response.collectionId!,
        );
        emit(state.copyWith(collections: updatedCollections));
        for (var collection in updatedCollections) {
          await _hiveManager.updateCollectionFavorite(
            collection.collectionId!,
            collection.isFavorite ?? false,
          );
        }
        if (event.isFavorite!) {
          if (favoriteCollection == null) {
            await showErrorMsg('No collections available.');
            return;
          }
          final unFavoriteResponse = await favoriteApiRequest(
            favoriteCollection.collectionId!,
            state.contentId!,
            false,
            true,
          );
          if (unFavoriteResponse != null) {
            add(
              UserFavoriteEvent(
                isFavorite: true,
                contentId: state.contentId,
                isShowLoading: true,
                isUpdatedFromFavoriteList: false,
              ),
            );
          }
        }
      } else {
        if (response != null) {
          GetIt.I<QuiltSnackBarManager>().showError(
            response.message ?? "Collection creation failed",
          );
        }
        emit(
          state.copyWith(
            createCollectionStatus:
                CreateCollectionStatus.createCollectionFailed,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          createCollectionStatus: CreateCollectionStatus.createCollectionFailed,
        ),
      );
    }
  }

  Future<void> _onDeleteCollection(
    DeleteCollection event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          deleteCollectionStatus: DeleteCollectionStatus.sendingRequest,
        ),
      );

      final response = await safeExecute<DeleteCollectionResponse>(
        function: () async {
          return await _deleteCollectionUseCases.execute(
            request: event.collectionId,
          );
        },
        showLoading: true,
        showError: false,
      );

      if (response != null) {
        if (state.favorites.isNotEmpty) {
          final List<String> contentIds = state.favorites
              .map((item) => item.content.id)
              .toList();

          _forYouBloc.add(
            UpdateContentItems(
              contentIds: contentIds,
              isFavorite: false,
              collectionId: event.collectionId,
            ),
          );
        }
        final deletedCollection = state.collections.firstWhere(
          (collection) => collection.collectionId == event.collectionId,
        );
        _hiveManager.deleteCollection(event.collectionId);
        final updatedCollections = _hiveManager.getCollectionsList();
        if (deletedCollection.isFavorite == true &&
            updatedCollections.isNotEmpty) {
          await _hiveManager.updateCollectionFavorite(
            updatedCollections.first.collectionId!,
            true,
          );
          final finalCollections = _hiveManager.getCollectionsList();
          emit(
            state.copyWith(
              deleteCollectionStatus:
                  DeleteCollectionStatus.deleteCollectionSuccess,
              collections: finalCollections,
            ),
          );
        } else {
          if (updatedCollections.isEmpty) {
            _initializeDefaultLibrary();
          }
          emit(
            state.copyWith(
              deleteCollectionStatus:
                  DeleteCollectionStatus.deleteCollectionSuccess,
              collections: _hiveManager.getCollectionsList(),
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            deleteCollectionStatus:
                DeleteCollectionStatus.deleteCollectionFailed,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          deleteCollectionStatus: DeleteCollectionStatus.deleteCollectionFailed,
        ),
      );
    }
  }

  Future<void> _onUpdateCollection(
    UpdateCollection event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          createCollectionStatus: CreateCollectionStatus.sendingRequest,
        ),
      );
      final response = await safeExecute<CreateCollectionResponse>(
        function: () async {
          return await _createCollectionUseCases.execute(
            request: CreateCollectionRequest(
              userId: _hiveManager.getFromHive(HiveManager.userIdKey)!,
              collectionName: event.collectionName,
              collectionId: event.collectionId,
            ),
          );
        },
        showLoading: true,
        showError: false,
      );

      if (response != null && response.statusCode == 0) {
        _hiveManager.updateCollection(
          CollectionObject(
            collectionId: response.collectionId,
            collectionName: response.collectionName,
          ),
          true,
        );
        emit(
          state.copyWith(
            updateCollectionStatus:
                UpdateCollectionStatus.updateCollectionSuccess,
            collections: _hiveManager.getCollectionsList(),
            selectedCollectionName: event.collectionName,
          ),
        );
      } else {
        if (response != null) {
          GetIt.I<QuiltSnackBarManager>().showError(
            response.message ?? "Collection update failed",
          );
        }
        emit(
          state.copyWith(
            updateCollectionStatus:
                UpdateCollectionStatus.updateCollectionFailed,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          updateCollectionStatus: UpdateCollectionStatus.updateCollectionFailed,
        ),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favoriteCollection = _getFavoriteCollectionOrNull();
      if (favoriteCollection == null) {
        add(GetCollections());
        return;
      }
      final unFavoriteResponse = await favoriteApiRequest(
        favoriteCollection.collectionId!,
        state.contentId!,
        false,
        true,
      );
      if (unFavoriteResponse != null) {
        var updatedCollections = updateFavoriteSelection(event.collectionId!);
        emit(state.copyWith(collections: updatedCollections));
        for (var collection in updatedCollections) {
          await _hiveManager.updateCollectionFavorite(
            collection.collectionId!,
            collection.isFavorite ?? false,
          );
        }
        if (event.isFavorite) {
          add(
            UserFavoriteEvent(
              isFavorite: true,
              contentId: state.contentId,
              isShowLoading: true,
              isUpdatedFromFavoriteList: false,
              feedScope: state.feedScope,
            ),
          );
        }
      }
    } catch (e) {
      //Error
    }
  }

  List<CollectionObject> updateFavoriteSelection(String collectionId) {
    final updatedCollections = state.collections
        .map(
          (collection) => collection.collectionId == collectionId
              ? collection.copyWith(isFavorite: true)
              : collection.copyWith(isFavorite: false),
        )
        .toList();
    return updatedCollections;
  }

  CollectionObject? _getFavoriteCollectionOrNull() {
    if (state.collections.isEmpty) return null;
    return state.collections.lastWhere(
      (collection) => collection.isFavorite ?? false,
      orElse: () => state.collections.first,
    );
  }

  Future<void> _onGetFavoriteList(
    GetFavoriteList event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          isLoading: event.pageSize == 1,
          createCollectionStatus: CreateCollectionStatus.unknown,
          deleteCollectionStatus: DeleteCollectionStatus.unknown,
          updateCollectionStatus: UpdateCollectionStatus.unknown,
          collectionId: event.collectionId,
          pageSize: event.pageSize,
          selectedCollectionName: event.collectionName,
          favorites: event.pageSize == 1 ? [] : null,
        ),
      );
      final response = await safeExecute<FavoriteListObject>(
        function: () async {
          return await _getFavoriteListUseCases.execute(
            request: FavoriteListRequest(
              limit: pageLimit,
              collectionId: state.collectionId!,
              page: state.pageSize!,
            ),
          );
        },
        showLoading: false,
        showError: false,
      );

      if (response != null && response.contentList.isNotEmpty) {
        emit(
          state.copyWith(
            favorites: [...state.favorites, ...response.contentList],
            hasReachedMax: response.contentList.length < 10,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(hasReachedMax: true, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onFavoriteContent(
    UserFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favoriteCollection = _getFavoriteCollectionOrNull();
      if (favoriteCollection == null) {
        add(GetCollections());
        return;
      }
      String collectionId = favoriteCollection.collectionId!;
      if (!event.isFavorite!) {
        collectionId = event.collectionId!;
      }
      emit(
        state.copyWith(
          favoriteStatus: FavoriteStatus.sendingRequest,
          favorites: !event.isUpdatedFromFavoriteList! ? [] : state.favorites,
          contentId: event.contentId ?? state.contentId,
          collectionId: collectionId,
          feedScope: event.feedScope,
        ),
      );
      final response = await favoriteApiRequest(
        collectionId,
        event.contentId ?? state.contentId!,
        event.isFavorite!,
        event.isShowLoading! ? true : false,
      );
      if (response != null) {
        if (state.feedScope == FeedScope.forYou) {
          _forYouBloc.add(
            UpdateContentCollectionDetails(
              contentId: event.contentId ?? state.contentId!,
              isFavorite: event.isFavorite!,
              collectionId: collectionId,
            ),
          );
        }

        if (!event.isUpdatedFromFavoriteList!) {
          GetIt.I<QuiltSnackBarManager>().showFavoriteSnackBar(
            state.collections
                .where((collection) => collectionId == collection.collectionId)
                .first
                .collectionName!,
            event.isFavorite!,
            () {
              if (state.feedScope == FeedScope.forYou) {
                _forYouBloc.add(
                  const HomeFeedShowCollectionUI(
                    ShowCollectionStatus.showCollectionUI,
                  ),
                );
              }
            },
          );
        }
        add(GetFavoriteCollectionsCount());
        if (event.isUpdatedFromFavoriteList!) {
          final updatedFavorites = List<ContentItem>.from(
            state.favorites,
          ).where((item) => item.content.id != event.contentId).toList();
          emit(
            state.copyWith(
              favoriteStatus: FavoriteStatus.favoriteSuccess,
              favorites: updatedFavorites,
            ),
          );
        } else {
          emit(state.copyWith(favoriteStatus: FavoriteStatus.favoriteSuccess));
        }
        if (event.isUpdatedFromFavoriteList!) {
          if (state.feedScope == FeedScope.forYou ||
              state.feedScope == FeedScope.following) {
            if (state.feedScope == FeedScope.forYou) {
              _forYouBloc.add(
                HomeFeedFavoritePressed(
                  isFavorite: false,
                  id: event.contentId!,
                  isUpdateFavorite: false,
                ),
              );
            }
          }
        }
      } else {
        if (state.feedScope == FeedScope.forYou ||
            state.feedScope == FeedScope.following) {
          if (state.feedScope == FeedScope.forYou) {
            _forYouBloc.add(
              UpdateContentCollectionDetails(
                contentId: event.contentId ?? state.contentId!,
                isFavorite: !event.isFavorite!,
                collectionId: collectionId,
              ),
            );
          } else {}
          emit(state.copyWith(favoriteStatus: FavoriteStatus.favoriteFailed));
        }
      }
    } catch (e) {
      emit(state.copyWith(favoriteStatus: FavoriteStatus.favoriteFailed));
    }
  }
}
