import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/data/network/core/dio_client.dart';
import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';
import 'package:quilt_flow_app/domain/session/session_repository.dart';

class SessionApi implements SessionRepository {
  final _dioClient = GetIt.I<DioClient>();
  static const String getUserDetails =
      '/api/ugc/v1/user/get-user-details?userId=';

  @override
  Future<UserDetailsData> getUserDetailsApi(String? request) async {
    final profileResponse = await _dioClient.getRequest<UserDetailsData>(
      "$getUserDetails$request",
      parseDataJson: UserDetailsData.fromJson,
    );
    return profileResponse;
  }
}
