import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';

abstract class SessionRepository {
  Future<UserDetailsData> getUserDetailsApi(String? userId);
}
