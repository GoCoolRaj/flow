import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

enum RegistrationStatus {
  unknown,
  verifyingInviteCode,
  inviteCodeVerified,
  invalidInviteCode,
  authenticatingUser,
  userAuthenticated,
  sendingOtp,
  otpSent,
  sendOtpFailed,
}

class RegistrationState extends Equatable {
  final RegistrationStatus status;
  final String inviteCode;
  final String? emailId;
  final bool isValidEmailId;
  final bool isInviteCodeVerified;
  final bool isLoading;
  final bool isPlaying;
  final bool isUserProfileUpdated;
  final VideoPlayerController? videoController;
  const RegistrationState({
    this.status = RegistrationStatus.unknown,
    this.inviteCode = '',
    this.emailId,
    this.isValidEmailId = false,
    this.isInviteCodeVerified = false,
    this.isLoading = false,
    this.isPlaying = false,
    this.isUserProfileUpdated = false,
    this.videoController,
  });

  RegistrationState copyWith({
    RegistrationStatus? status,
    String? inviteCode,
    String? emailId,
    bool? isValidEmailId,
    bool? isInviteCodeVerified,
    bool? isLoading,
    bool? isPlaying,
    bool? isUserProfileUpdated,
    VideoPlayerController? videoController,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      inviteCode: inviteCode ?? this.inviteCode,
      emailId: emailId ?? this.emailId,
      isValidEmailId: isValidEmailId ?? this.isValidEmailId,
      isInviteCodeVerified: isInviteCodeVerified ?? this.isInviteCodeVerified,
      videoController: videoController ?? this.videoController,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      isUserProfileUpdated: isUserProfileUpdated ?? this.isUserProfileUpdated,
    );
  }

  @override
  List<Object?> get props => [
        status,
        inviteCode,
        emailId,
        isValidEmailId,
        isInviteCodeVerified,
        isLoading,
        isPlaying,
        isUserProfileUpdated,
        videoController,
      ];
}
