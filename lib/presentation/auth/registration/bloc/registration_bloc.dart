import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/app/helpers/extensions/string_extensions.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/data/network/core/api_exception.dart';
import 'package:quilt_flow_app/domain/auth/login/model/login_email_otp_response.dart';
import 'package:quilt_flow_app/domain/auth/login/model/login_email_otp_verify_response.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/login_send_email_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/verify_login_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/registration/model/verify_invite_code_response.dart';
import 'package:quilt_flow_app/domain/auth/registration/use_cases/verify_invite_code_use_case.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_event.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_state.dart';
import 'package:quilt_flow_app/presentation/auth/registration/bloc/registration_event.dart';
import 'package:quilt_flow_app/presentation/auth/registration/bloc/registration_state.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_bloc.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_event.dart';
import 'package:video_player/video_player.dart';

class RegistrationBloc extends BaseBloc<RegistrationEvent, RegistrationState> {
  late final _otpBloc = getIt.get<OtpBloc>();
  late final _hiveManager = getIt<HiveManager>();
  late final _sessionBloc = getIt.get<SessionBloc>();

  StreamSubscription<OtpState>? _otpStateStreamSubscription;

  RegistrationBloc() : super(const RegistrationState()) {
    on<InviteCodeChanged>(_onInviteCodeChanged);
    on<InviteCodeSubmitted>(_onInviteCodeSubmitted);
    on<EmailIdChanged>(_onEmailIdChanged);
    on<EmailIdCompleted>(_onEmailIdCompleted);
    on<LoginWithEmailRequested>(_onLoginWithEmailRequested);
    on<ValidateLoginEmailOtpRequested>(_onValidateLoginEmailOtpRequested);
    on<FabricTutorialInitializePlayer>(_onInitializePlayer);
    on<FabricTutorialPauseMedia>(_onPauseMedia);
    on<FabricTutorialPlayMedia>(_onPlayMedia);
  }

  FutureOr<void> _onInviteCodeChanged(
    InviteCodeChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        inviteCode: event.inviteCode,
        isInviteCodeVerified: false,
        emailId: null,
        isValidEmailId: false,
        status: RegistrationStatus.unknown,
      ),
    );
  }

  FutureOr<void> _onInviteCodeSubmitted(
    InviteCodeSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    if (state.inviteCode.isEmpty) {
      await showErrorMsg("Please enter an invite code");
      return;
    }

    emit(state.copyWith(status: RegistrationStatus.verifyingInviteCode));
    try {
      final response = await safeExecute<VerifyInviteCodeResponse>(
        function: () async {
          return await getIt.get<VerifyInviteCodeUseCase>().execute(
            request: VerifyInviteCodeRequest(
              clinicCode: state.inviteCode.trim(),
            ),
          );
        },
        showLoading: true,
      );

      if (response == null) {
        emit(state.copyWith(status: RegistrationStatus.invalidInviteCode));
        return;
      }

      emit(
        state.copyWith(
          status: RegistrationStatus.inviteCodeVerified,
          emailId: response.email,
          isInviteCodeVerified: true,
          isValidEmailId: response.email.isEmail,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: RegistrationStatus.invalidInviteCode));
    }
  }

  FutureOr<void> _onEmailIdChanged(
    EmailIdChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        emailId: event.emailId.normalizedEmail,
        isValidEmailId: event.emailId.isEmail,
      ),
    );
  }

  FutureOr<void> _onEmailIdCompleted(
    EmailIdCompleted event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(isValidEmailId: event.isValidEmailId));
  }

  FutureOr<void> _onLoginWithEmailRequested(
    LoginWithEmailRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    if (!state.isInviteCodeVerified) {
      await showErrorMsg("Please verify your invite code first");
      return;
    }

    if (!(state.emailId?.isEmail ?? false)) {
      await showErrorMsg("Please enter a valid email");
      return;
    }

    await _requestOtpForEmail(emit, event.resendRequest);
  }

  FutureOr<void> _requestOtpForEmail(
    Emitter<RegistrationState> emit,
    bool resendRequest,
  ) async {
    emit(state.copyWith(status: RegistrationStatus.sendingOtp));

    await safeExecute<LoginEmailOtpResponse>(
      function: () async {
        return await getIt.get<LoginSendEmailOtpUseCase>().execute(
          request: LoginEmailOtpRequest(email: state.emailId ?? ''),
        );
      },
      showLoading: true,
      showError: false,
    );

    if (resendRequest) {
      await showSuccessMsg("OTP resent successfully");
    }

    _otpBloc.add(
      OtpRequested(emailId: state.emailId ?? '', otpExpireDuration: 60),
    );
    _listenToOtpBloc();
    emit(state.copyWith(status: RegistrationStatus.otpSent));
  }

  FutureOr<void> _onValidateLoginEmailOtpRequested(
    ValidateLoginEmailOtpRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      final response = await safeExecute<LoginEmailOtpVerifyResponse>(
        function: () async {
          return await getIt.get<VerifyLoginOtpUseCase>().execute(
            request: VerifyLoginOtpRequest(
              email: state.emailId ?? '',
              otpCode: event.otpCode,
            ),
          );
        },
        showLoading: true,
        showError: false,
      );

      if (response == null) {
        return;
      }

      await showSuccessMsg("Logged in successfully");

      await _hiveManager.saveToHive(
        HiveManager.userSessionTokenKey,
        response.sessionToken,
      );

      await _hiveManager.saveToHive(HiveManager.userIdKey, response.userId);

      await _hiveManager.saveToHive(
        HiveManager.userProfileUpdated,
        response.isUserProfileUpdated,
      );

      await _hiveManager.saveToHive(
        HiveManager.fabricCreationUpdated,
        !response.hasAtleastOnePrivateFlag,
      );
      await _hiveManager.saveToHive(
        HiveManager.profileImageCreationUpdated,
        !response.hasAtleastOnePrivateFlag,
      );
      await _hiveManager.saveToHive(HiveManager.userName, response.userName);
      await _hiveManager.saveToHive(
        HiveManager.userProfileUpdated,
        response.isUserProfileUpdated,
      );

      _sessionBloc.add(UpdateUserId(userId: response.userId));

      emit(
        state.copyWith(
          status: RegistrationStatus.userAuthenticated,
          isUserProfileUpdated: response.isUserProfileUpdated,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        _otpBloc.add(const VerifyOtpFailed());
      } else if (e is BadResponseException) {
        _otpBloc.add(const VerifyOtpFailed());
      }
    }
  }

  void _listenToOtpBloc() {
    _otpStateStreamSubscription = _otpBloc.stream.listen((state) {
      switch (state.status) {
        case OtpStatus.resendOtp:
          if (this.state.isInviteCodeVerified &&
              (this.state.emailId?.isEmail ?? false)) {
            add(const LoginWithEmailRequested(resendRequest: true));
          }
          break;
        case OtpStatus.verifyOtp:
          if (this.state.isInviteCodeVerified &&
              (this.state.emailId?.isEmail ?? false)) {
            add(ValidateLoginEmailOtpRequested(state.otpCode));
          }
          break;
        default:
          break;
      }
    });
  }

  Future<void> _onInitializePlayer(
    FabricTutorialInitializePlayer event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      if (event.videoUrl == null) return;
      VideoPlayerController? videoController;
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(event.videoUrl!),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      videoController.setLooping(true);
      emit(state.copyWith(videoController: videoController));
      await videoController.initialize();
      await videoController.play();
      emit(state.copyWith(isLoading: false, isPlaying: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onPauseMedia(
    FabricTutorialPauseMedia event,
    Emitter<RegistrationState> emit,
  ) async {
    await state.videoController?.pause();
    emit(state.copyWith(isPlaying: false));
  }

  Future<void> _onPlayMedia(
    FabricTutorialPlayMedia event,
    Emitter<RegistrationState> emit,
  ) async {
    await state.videoController?.play();
    emit(state.copyWith(isPlaying: true));
  }

  @override
  Future<void> close() {
    _otpStateStreamSubscription?.cancel();
    state.videoController?.dispose();
    return super.close();
  }
}
