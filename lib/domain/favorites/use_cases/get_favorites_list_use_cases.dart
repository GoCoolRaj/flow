import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/favorites/favorites_repository.dart';
import 'package:quilt_flow_app/domain/favorites/model/favorite_list_object.dart';

class GetFavoritesListUseCases
    implements BaseUseCase<FavoriteListRequest, FavoriteListObject> {
  final _favoriteRepository = GetIt.I<FavoritesRepository>();

  @override
  Future<FavoriteListObject> execute({FavoriteListRequest? request}) {
    return _favoriteRepository.getFavoriteListApi(request!);
  }
}

class FavoriteListRequest {
  final int limit;
  final String collectionId;
  final int page;

  FavoriteListRequest({
    required this.limit,
    required this.collectionId,
    required this.page,
  });
}
