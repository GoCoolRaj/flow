import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/data/network/core/dio_client.dart';
import 'package:quilt_flow_app/domain/create_profile/model/create_profile_response.dart';
import 'package:quilt_flow_app/domain/favorites/favorites_repository.dart';
import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';
import 'package:quilt_flow_app/domain/favorites/model/create_collection_response.dart';
import 'package:quilt_flow_app/domain/favorites/model/delete_collection_response.dart';
import 'package:quilt_flow_app/domain/favorites/model/favorite_list_object.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/create_collection_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/favorite_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/get_favorites_list_use_cases.dart';

class FavoritesApi implements FavoritesRepository {
  final _dioClient = GetIt.I<DioClient>();
  static const String createCollection =
      '/api/ugc/v1/favourites/add-or-update-collections';
  static const String getCollectionList =
      '/api/ugc/v1/favourites/collections?userId=';
  static const String deleteCollection =
      '/api/ugc/v1/favourites/collections?userId=';
  static const String favoriteList = '/api/ugc/v1/favourites/contents?userId=';
  static const String favorite =
      '/api/ugc/v1/favourites/add-or-update-favourite';
  late final _hiveManager = GetIt.I<HiveManager>();

  @override
  Future<CreateCollectionResponse> createCollectionApi(
    CreateCollectionRequest request,
  ) async {
    final createCollectionResponse = await _dioClient
        .postRequest<CreateCollectionResponse>(
          createCollection,
          data: request.toJson(),
          parseDataJson: CreateCollectionResponse.fromJson,
        );

    return createCollectionResponse;
  }

  @override
  Future<List<CollectionObject>> getCollectionListApi(String userId) async {
    final collectionListResponse = await _dioClient
        .getRequest<List<CollectionObject>>(
          "$getCollectionList$userId",
          parseListDataJson: CollectionObject.parseFavoriteCollectionList,
        );
    return collectionListResponse;
  }

  @override
  Future<DeleteCollectionResponse> deleteCollectionApi(String request) async {
    final deleteCollectionResponse = await _dioClient
        .deleteRequest<DeleteCollectionResponse>(
          "$deleteCollection${_hiveManager.getFromHive(HiveManager.userIdKey)!}&collectionId=$request",
          parseDataJson: DeleteCollectionResponse.fromJson,
        );
    return deleteCollectionResponse;
  }

  @override
  Future<FavoriteListObject> getFavoriteListApi(
    FavoriteListRequest request,
  ) async {
    String collectionId = request.collectionId;
    int page = request.page;
    int limit = request.limit;
    final favoriteListApiResponse = await _dioClient.getRequest<FavoriteListObject>(
      "$favoriteList${_hiveManager.getFromHive(HiveManager.userIdKey)!}&collectionId=$collectionId&page=$page&limit=$limit",
      parseDataJson: FavoriteListObject.parseCollectionList,
    );
    return favoriteListApiResponse;
  }

  @override
  Future<CreateProfileResponse> favoriteApi(FavoriteRequest request) async {
    final favoriteResponse = await _dioClient
        .postRequest<CreateProfileResponse>(
          favorite,
          data: request.toJson(),
          parseDataJson: CreateProfileResponse.fromJson,
        );

    return favoriteResponse;
  }
}
