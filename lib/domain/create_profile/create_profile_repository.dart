import 'package:quilt_flow_app/domain/create_profile/model/create_profile_response.dart';
import 'package:quilt_flow_app/domain/create_profile/use_cases/create_profile_use_cases.dart';

abstract class CreateProfileRepository {
  Future<CreateProfileResponse> createProfile(CreateProfileRequest request);
}
