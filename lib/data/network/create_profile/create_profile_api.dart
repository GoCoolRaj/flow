import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/data/network/core/dio_client.dart';
import 'package:quilt_flow_app/domain/create_profile/create_profile_repository.dart';
import 'package:quilt_flow_app/domain/create_profile/model/create_profile_response.dart';
import 'package:quilt_flow_app/domain/create_profile/use_cases/create_profile_use_cases.dart';

class CreateProfileApi implements CreateProfileRepository {
  final _dioClient = GetIt.I<DioClient>();

  static const String updateUserPath = '/api/ugc/v1/user/update-user';

  @override
  Future<CreateProfileResponse> createProfile(
    CreateProfileRequest request,
  ) async {
    final response = await _dioClient.postRequest<CreateProfileResponse>(
      updateUserPath,
      data: request.toJson(),
      parseDataJson: CreateProfileResponse.fromJson,
    );
    return response;
  }
}
