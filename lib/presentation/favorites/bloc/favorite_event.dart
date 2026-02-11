import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/favorites/model/favorite_list_object.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';

sealed class FavoritesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class CreateCollection extends FavoritesEvent {
  final String? collectionName;
  final bool? isFavorite;
  CreateCollection({this.collectionName, this.isFavorite});
}

class GetCollections extends FavoritesEvent {}

class GetFavoriteCollectionsCount extends FavoritesEvent {}

class DeleteCollection extends FavoritesEvent {
  final String collectionId;
  DeleteCollection(this.collectionId);
}

class UpdateCollection extends FavoritesEvent {
  final String collectionId;
  final String collectionName;
  UpdateCollection({required this.collectionId, required this.collectionName});
}

class AddToCollection extends FavoritesEvent {
  final String collectionId;
  final String experienceId;

  AddToCollection({required this.collectionId, required this.experienceId});
}

class RemoveFromCollection extends FavoritesEvent {
  final String collectionId;
  final String experienceId;

  RemoveFromCollection({
    required this.collectionId,
    required this.experienceId,
  });
}

class ToggleCreateView extends FavoritesEvent {
  final bool show;

  ToggleCreateView(this.show);
}

class ToggleUpdateView extends FavoritesEvent {
  final bool show;

  ToggleUpdateView(this.show);
}

class ToggleNewCollectionCreateView extends FavoritesEvent {
  final bool show;

  ToggleNewCollectionCreateView(this.show);
}

class CollectionNameChanged extends FavoritesEvent {
  final String collectionName;

  CollectionNameChanged(this.collectionName);
}

class ToggleFavorite extends FavoritesEvent {
  final String? collectionId;
  final bool isFavorite;
  ToggleFavorite({this.collectionId, this.isFavorite = true});
}

class InitFavorite extends FavoritesEvent {
  InitFavorite();
}

class GetFavoriteList extends FavoritesEvent {
  final String? collectionId;
  final String? collectionName;
  final int? pageSize;
  final List<FavoriteListObject>? favorites;

  GetFavoriteList({
    this.pageSize,
    this.collectionId,
    this.collectionName,
    this.favorites,
  });
}

class UserFavoriteEvent extends FavoritesEvent {
  final String? contentId;
  final String? collectionId;
  final bool? isFavorite;
  final bool? isUpdatedFromFavoriteList;
  final bool? isShowLoading;
  final FeedScope? feedScope;
  UserFavoriteEvent({
    this.isFavorite,
    this.contentId,
    this.collectionId,
    this.isShowLoading = false,
    this.isUpdatedFromFavoriteList = false,
    this.feedScope = FeedScope.profile,
  });
}
