// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/auth/auth_repository.dart';
import 'package:quilt_flow_app/domain/auth/login/model/login_email_otp_response.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';

class LoginSendEmailOtpUseCase
    extends BaseUseCase<LoginEmailOtpRequest, LoginEmailOtpResponse> {
  final _authRepository = GetIt.I<AuthRepository>();

  @override
  Future<LoginEmailOtpResponse> execute({LoginEmailOtpRequest? request}) {
    return _authRepository.loginSendEmailOtp(request!);
  }
}

class LoginEmailOtpRequest {
  final String email;

  LoginEmailOtpRequest({required this.email});

  LoginEmailOtpRequest copyWith({String? email}) {
    return LoginEmailOtpRequest(email: email ?? this.email);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'email': email};
  }

  factory LoginEmailOtpRequest.fromMap(Map<String, dynamic> map) {
    return LoginEmailOtpRequest(email: map['email'] as String);
  }

  String toJson() => json.encode(toMap());

  factory LoginEmailOtpRequest.fromJson(String source) =>
      LoginEmailOtpRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LoginUserRequest(email: $email)';
}
