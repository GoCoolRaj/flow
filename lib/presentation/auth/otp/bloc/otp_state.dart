import 'package:equatable/equatable.dart';

enum OtpStatus {
  unknown,
  otpRequested,
  otpCodeChanged,
  otpCodeCompleted,
  resendOtp,
  verifyOtp,
  verifyOtpFailed,
}

class OtpState extends Equatable {
  final OtpStatus status;
  final String emailId;
  final bool resendOtpEnabled;
  final int otpResendDuration;
  final int otpCode;

  const OtpState({
    this.status = OtpStatus.unknown,
    this.emailId = '',
    this.resendOtpEnabled = false,
    this.otpResendDuration = 120,
    this.otpCode = -1,
  });

  OtpState copyWith({
    OtpStatus? status,
    String? emailId,
    bool? resendOtpEnabled,
    int? otpResendDuration,
    int? otpCode,
  }) {
    return OtpState(
      status: status ?? this.status,
      emailId: emailId ?? this.emailId,
      resendOtpEnabled: resendOtpEnabled ?? this.resendOtpEnabled,
      otpResendDuration: otpResendDuration ?? this.otpResendDuration,
      otpCode: otpCode ?? this.otpCode,
    );
  }

  @override
  List<Object> get props => [
    status,
    emailId,
    resendOtpEnabled,
    otpResendDuration,
    otpCode,
  ];
}
