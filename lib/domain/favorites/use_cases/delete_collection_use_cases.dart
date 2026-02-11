import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/favorites/favorites_repository.dart';
import 'package:quilt_flow_app/domain/favorites/model/delete_collection_response.dart';

class DeleteCollectionUseCases
    implements BaseUseCase<String, DeleteCollectionResponse> {
  final _favoriteRepository = GetIt.I<FavoritesRepository>();

  @override
  Future<DeleteCollectionResponse> execute({String? request}) {
    return _favoriteRepository.deleteCollectionApi(request!);
  }
}
