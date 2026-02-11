import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';

enum CreateCollectionStatus {
  unknown,
  createCollectionSuccess,
  createCollectionFailed,
  sendingRequest,
}

enum FavoriteStatus { unknown, favoriteSuccess, favoriteFailed, sendingRequest }

enum DeleteCollectionStatus {
  unknown,
  sendingRequest,
  deleteCollectionSuccess,
  deleteCollectionFailed,
}

enum UpdateCollectionStatus {
  unknown,
  sendingRequest,
  updateCollectionSuccess,
  updateCollectionFailed,
}

class FavoritesState extends Equatable {
  final List<CollectionObject> collections;
  final List<ContentItem> favorites;
  final bool isLoading;
  final bool hasReachedMax;
  final String? collectionName;
  final String? selectedCollectionName;
  final String? collectionId;
  final String? contentId;
  final int? limit;
  final int? pageSize;
  final bool isCreateView;
  final bool isUpdateView;
  final bool isNewCollectionCreateView;
  final bool isCreateCollectionEnabled;
  final CreateCollectionStatus createCollectionStatus;
  final UpdateCollectionStatus updateCollectionStatus;
  final DeleteCollectionStatus deleteCollectionStatus;
  final FavoriteStatus favoriteStatus;
  final FeedScope? feedScope;

  const FavoritesState({
    this.collections = const [],
    this.favorites = const [],
    this.isLoading = false,
    this.isCreateView = false,
    this.isUpdateView = false,
    this.isNewCollectionCreateView = false,
    this.limit = 10,
    this.pageSize = 1,
    this.contentId,
    this.hasReachedMax = false,
    this.isCreateCollectionEnabled = false,
    this.createCollectionStatus = CreateCollectionStatus.unknown,
    this.updateCollectionStatus = UpdateCollectionStatus.unknown,
    this.deleteCollectionStatus = DeleteCollectionStatus.unknown,
    this.favoriteStatus = FavoriteStatus.unknown,
    this.collectionName,
    this.selectedCollectionName,
    this.collectionId,
    this.feedScope = FeedScope.initial,
  });

  FavoritesState copyWith({
    List<CollectionObject>? collections,
    bool? isLoading,
    bool? isCreateView,
    bool? isUpdateView,
    bool? isNewCollectionCreateView,
    bool? isCreateCollectionEnabled,
    String? collectionName,
    String? selectedCollectionName,
    String? collectionId,
    String? contentId,
    int? limit,
    bool? hasReachedMax,
    List<ContentItem>? favorites,
    int? pageSize,
    CreateCollectionStatus? createCollectionStatus,
    FavoriteStatus? favoriteStatus,
    UpdateCollectionStatus? updateCollectionStatus,
    DeleteCollectionStatus? deleteCollectionStatus,
    FeedScope? feedScope,
  }) {
    return FavoritesState(
      collections: collections ?? this.collections,
      isLoading: isLoading ?? this.isLoading,
      isCreateView: isCreateView ?? this.isCreateView,
      isUpdateView: isUpdateView ?? this.isUpdateView,
      isCreateCollectionEnabled:
          isCreateCollectionEnabled ?? this.isCreateCollectionEnabled,
      collectionName: collectionName ?? this.collectionName,
      createCollectionStatus:
          createCollectionStatus ?? this.createCollectionStatus,
      updateCollectionStatus:
          updateCollectionStatus ?? this.updateCollectionStatus,
      deleteCollectionStatus:
          deleteCollectionStatus ?? this.deleteCollectionStatus,
      collectionId: collectionId ?? this.collectionId,
      limit: limit ?? this.limit,
      pageSize: pageSize ?? this.pageSize,
      contentId: contentId ?? this.contentId,
      isNewCollectionCreateView:
          isNewCollectionCreateView ?? this.isNewCollectionCreateView,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      favorites: favorites ?? this.favorites,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      selectedCollectionName:
          selectedCollectionName ?? this.selectedCollectionName,
      feedScope: feedScope ?? this.feedScope,
    );
  }

  @override
  List<Object?> get props => [
    collections,
    isLoading,
    collectionName,
    isCreateView,
    isCreateCollectionEnabled,
    createCollectionStatus,
    deleteCollectionStatus,
    updateCollectionStatus,
    favoriteStatus,
    collectionId,
    limit,
    pageSize,
    hasReachedMax,
    isUpdateView,
    favorites,
    contentId,
    isNewCollectionCreateView,
    selectedCollectionName,
    feedScope,
  ];
}
