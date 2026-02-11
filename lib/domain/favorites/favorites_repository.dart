import 'package:quilt_flow_app/domain/create_profile/model/create_profile_response.dart';
import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';
import 'package:quilt_flow_app/domain/favorites/model/create_collection_response.dart';
import 'package:quilt_flow_app/domain/favorites/model/delete_collection_response.dart';
import 'package:quilt_flow_app/domain/favorites/model/favorite_list_object.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/create_collection_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/favorite_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/get_favorites_list_use_cases.dart';

abstract class FavoritesRepository {
  Future<CreateCollectionResponse> createCollectionApi(
    CreateCollectionRequest request,
  );
  Future<List<CollectionObject>> getCollectionListApi(String request);
  Future<DeleteCollectionResponse> deleteCollectionApi(String request);
  Future<FavoriteListObject> getFavoriteListApi(FavoriteListRequest request);
  Future<CreateProfileResponse> favoriteApi(FavoriteRequest request);
}
