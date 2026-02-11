import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/fabric_creation/fabric_gen_repository.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/check_fabric_image_response.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/check_fabric_images_request.dart';

class CheckFabricImagesUseCase
    extends BaseUseCase<CheckFabricImagesRequest, CheckFabricImageResponse> {
  final _fabricRepository = GetIt.I.get<FabricGenRepository>();

  @override
  Future<CheckFabricImageResponse> execute({
    CheckFabricImagesRequest? request,
  }) {
    return _fabricRepository.checkFabricImages(request!);
  }
}
