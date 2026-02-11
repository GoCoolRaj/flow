import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/favorites/favorites_repository.dart';
import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';

class GetCollectionListUseCases
    implements BaseUseCase<String, List<CollectionObject>> {
  final _favoriteRepository = GetIt.I<FavoritesRepository>();

  @override
  Future<List<CollectionObject>> execute({String? request}) {
    return _favoriteRepository.getCollectionListApi(request!);
  }
}
