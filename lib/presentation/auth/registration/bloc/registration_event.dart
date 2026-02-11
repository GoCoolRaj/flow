import 'package:equatable/equatable.dart';

sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class InviteCodeChanged extends RegistrationEvent {
  final String inviteCode;
  const InviteCodeChanged(this.inviteCode);

  @override
  List<Object> get props => [inviteCode];
}

class InviteCodeSubmitted extends RegistrationEvent {
  const InviteCodeSubmitted();

  @override
  List<Object> get props => [];
}

class EmailIdChanged extends RegistrationEvent {
  final String emailId;
  const EmailIdChanged(this.emailId);

  @override
  List<Object> get props => [emailId];
}

class EmailIdCompleted extends RegistrationEvent {
  final String? emailId;
  final bool isValidEmailId;

  const EmailIdCompleted({
    this.emailId,
    required this.isValidEmailId,
  });

  @override
  List<Object?> get props => [emailId, isValidEmailId];
}

class LoginWithEmailRequested extends RegistrationEvent {
  final bool resendRequest;
  const LoginWithEmailRequested({
    required this.resendRequest,
  });

  @override
  List<Object?> get props => [resendRequest];
}

class ValidateLoginEmailOtpRequested extends RegistrationEvent {
  final int otpCode;
  const ValidateLoginEmailOtpRequested(this.otpCode);

  @override
  List<Object?> get props => [otpCode];
}

class FabricTutorialPlayMedia extends RegistrationEvent {
  @override
  List<Object?> get props => [];
}

class FabricTutorialPauseMedia extends RegistrationEvent {
  @override
  List<Object?> get props => [];
}

class FabricTutorialInitializePlayer extends RegistrationEvent {
  final String? videoUrl;
  const FabricTutorialInitializePlayer({this.videoUrl});
  @override
  List<Object?> get props => [videoUrl];
}
