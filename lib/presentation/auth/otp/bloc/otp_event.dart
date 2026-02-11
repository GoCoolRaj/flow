import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpRequested extends OtpEvent {
  final String emailId;
  final int otpExpireDuration;

  const OtpRequested({
    required this.emailId,
    required this.otpExpireDuration,
  });

  @override
  List<Object?> get props => [
        emailId,
        otpExpireDuration,
      ];
}

class ResendOtpRequested extends OtpEvent {
  const ResendOtpRequested();
}

class ResendOtpDurationFinished extends OtpEvent {
  const ResendOtpDurationFinished();
}

class OtpCodeChanged extends OtpEvent {
  final String otpCode;

  const OtpCodeChanged(this.otpCode);

  @override
  List<Object?> get props => [otpCode];
}

class OtpCodeCompleted extends OtpEvent {
  final int otpCode;

  const OtpCodeCompleted(this.otpCode);

  @override
  List<Object?> get props => [otpCode];
}

class ValidateOtpRequested extends OtpEvent {
  const ValidateOtpRequested();
}

class VerifyOtpFailed extends OtpEvent {
  const VerifyOtpFailed();
}

class OtpFieldTapped extends OtpEvent {
  const OtpFieldTapped();
}
