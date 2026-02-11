import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';
import 'package:quilt_flow_app/domain/session/session_repository.dart';

class GetSessionUserDetailsUsecase
    implements BaseUseCase<String, UserDetailsData> {
  final sessionRepository = GetIt.I<SessionRepository>();

  @override
  Future<UserDetailsData> execute({String? request}) {
    return sessionRepository.getUserDetailsApi(request!);
  }
}
