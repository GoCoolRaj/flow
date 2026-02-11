import 'package:quilt_flow_app/domain/auth/login/model/login_email_otp_response.dart';
import 'package:quilt_flow_app/domain/auth/login/model/login_email_otp_verify_response.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/login_send_email_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/verify_login_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/registration/model/verify_invite_code_response.dart';
import 'package:quilt_flow_app/domain/auth/registration/use_cases/verify_invite_code_use_case.dart';

abstract class AuthRepository {
  Future<LoginEmailOtpResponse> loginSendEmailOtp(LoginEmailOtpRequest request);

  Future<LoginEmailOtpVerifyResponse> verifyLoginOtp(
    VerifyLoginOtpRequest request,
  );

  Future<VerifyInviteCodeResponse> verifyInviteCode(
    VerifyInviteCodeRequest request,
  );
}
