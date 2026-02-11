import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/auth/auth_repository.dart';
import 'package:quilt_flow_app/domain/auth/login/model/login_email_otp_verify_response.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';

class VerifyLoginOtpUseCase
    extends BaseUseCase<VerifyLoginOtpRequest, LoginEmailOtpVerifyResponse> {
  final _authRepository = GetIt.instance.get<AuthRepository>();
  @override
  Future<LoginEmailOtpVerifyResponse> execute({
    VerifyLoginOtpRequest? request,
  }) {
    return _authRepository.verifyLoginOtp(request!);
  }
}

class VerifyLoginOtpRequest {
  final String email;
  final int otpCode;

  VerifyLoginOtpRequest({required this.email, required this.otpCode});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'email': email, 'otp': otpCode};
  }

  String toJson() => json.encode(toMap());
}
