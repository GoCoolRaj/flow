import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/fabric_creation/fabric_gen_repository.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/unique_fabric_request.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/unique_fabric_response.dart';

class UniqueFabricUseCase
    extends BaseUseCase<UniqueFabricRequest, UniqueFabricResponse> {
  final _fabricRepository = GetIt.I.get<FabricGenRepository>();

  @override
  Future<UniqueFabricResponse> execute({
    UniqueFabricRequest? request,
    CancelToken? cancelToken,
  }) {
    return _fabricRepository.isFabricUnique(request!, cancelToken: cancelToken);
  }
}
