import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

enum LoginStatus {
  unknown,
  authenticatingUser,
  userAuthenticated,
  sendingOtp,
  otpSent,
  sendOtpFailed,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String? emailId;
  final bool isValidEmailId;
  final bool isLoading;
  final bool isPlaying;
  final bool isUserProfileUpdated;
  final VideoPlayerController? videoController;
  const LoginState({
    this.status = LoginStatus.unknown,
    this.emailId,
    this.isValidEmailId = false,
    this.isLoading = false,
    this.isPlaying = false,
    this.isUserProfileUpdated = false,
    this.videoController,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? emailId,
    bool? isValidEmailId,
    bool? isLoading,
    bool? isPlaying,
    bool? isUserProfileUpdated,
    VideoPlayerController? videoController,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailId: emailId ?? this.emailId,
      isValidEmailId: isValidEmailId ?? this.isValidEmailId,
      videoController: videoController ?? this.videoController,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      isUserProfileUpdated: isUserProfileUpdated ?? this.isUserProfileUpdated,
    );
  }

  @override
  List<Object?> get props => [
        status,
        emailId,
        isValidEmailId,
        isLoading,
        isPlaying,
        isUserProfileUpdated,
        videoController,
      ];
}
