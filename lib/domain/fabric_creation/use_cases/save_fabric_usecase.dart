import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/fabric_creation/fabric_gen_repository.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/save_fabric_request.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/save_fabric_response.dart';

class SaveFabricUseCase
    extends BaseUseCase<SaveFabricRequest, SaveFabricResponse> {
  final _fabricRepository = GetIt.I.get<FabricGenRepository>();

  @override
  Future<SaveFabricResponse> execute({SaveFabricRequest? request}) {
    return _fabricRepository.saveFabric(request!);
  }
}
