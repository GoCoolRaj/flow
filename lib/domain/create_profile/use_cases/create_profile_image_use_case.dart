import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/create_profile/model/create_profile_image_request.dart';
import 'package:quilt_flow_app/domain/fabric_creation/fabric_gen_repository.dart';
import 'package:quilt_flow_app/domain/fabric_creation/model/create_fabric_response.dart';

class CreateProfileImageUseCase
    extends BaseUseCase<CreateProfileImageRequest, CreateFabricResponse> {
  final _fabricRepository = GetIt.I.get<FabricGenRepository>();

  @override
  Future<CreateFabricResponse> execute({CreateProfileImageRequest? request}) {
    return _fabricRepository.createProfileImageFabric(request!);
  }
}
