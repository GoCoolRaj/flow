import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/data/network/core/dio_client.dart';
import 'package:quilt_flow_app/domain/auth/auth_repository.dart';
import 'package:quilt_flow_app/domain/auth/login/model/login_email_otp_response.dart';
import 'package:quilt_flow_app/domain/auth/login/model/login_email_otp_verify_response.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/login_send_email_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/verify_login_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/registration/model/verify_invite_code_response.dart';
import 'package:quilt_flow_app/domain/auth/registration/use_cases/verify_invite_code_use_case.dart';

class AuthApi extends AuthRepository {
  final _dioClient = GetIt.I<DioClient>();

  static const String pathSendOtpEmail = '/api/ugc/v1/auth/send-otp-email';
  static const String pathVerifyOtpEmail =
      '/api/ugc/v1/auth/verify-email-otp-and-login';
  static const String pathVerifyInviteCode =
      '/api/ugc/v1/auth/get-email-by-clinic-code';

  @override
  Future<LoginEmailOtpResponse> loginSendEmailOtp(
    LoginEmailOtpRequest request,
  ) async {
    final loginResponse = await _dioClient.postRequest<LoginEmailOtpResponse>(
      pathSendOtpEmail,
      data: request.toJson(),
      parseDataJson: LoginEmailOtpResponse.fromJson,
    );

    return loginResponse;
  }

  @override
  Future<LoginEmailOtpVerifyResponse> verifyLoginOtp(
    VerifyLoginOtpRequest request,
  ) {
    final verifyResponse = _dioClient.postRequest<LoginEmailOtpVerifyResponse>(
      pathVerifyOtpEmail,
      data: request.toJson(),
      parseDataJson: LoginEmailOtpVerifyResponse.fromJson,
    );

    return verifyResponse;
  }

  @override
  Future<VerifyInviteCodeResponse> verifyInviteCode(
    VerifyInviteCodeRequest request,
  ) async {
    final response = await _dioClient.postRequest<VerifyInviteCodeResponse>(
      pathVerifyInviteCode,
      data: request.toJson(),
      parseDataJson: VerifyInviteCodeResponse.fromJson,
    );

    return response;
  }
}
