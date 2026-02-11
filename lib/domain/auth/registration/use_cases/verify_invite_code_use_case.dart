import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/auth/auth_repository.dart';
import 'package:quilt_flow_app/domain/auth/registration/model/verify_invite_code_response.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';

class VerifyInviteCodeUseCase
    extends BaseUseCase<VerifyInviteCodeRequest, VerifyInviteCodeResponse> {
  final _authRepository = GetIt.I<AuthRepository>();

  @override
  Future<VerifyInviteCodeResponse> execute({VerifyInviteCodeRequest? request}) {
    return _authRepository.verifyInviteCode(request!);
  }
}

class VerifyInviteCodeRequest {
  final String clinicCode;

  VerifyInviteCodeRequest({required this.clinicCode});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'clinicCode': clinicCode};
  }

  String toJson() => json.encode(toMap());
}
