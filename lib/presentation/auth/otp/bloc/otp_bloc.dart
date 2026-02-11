import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_event.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_state.dart';

class OtpBloc extends BaseBloc<OtpEvent, OtpState> {
  final int otpLength = 4;

  OtpBloc() : super(const OtpState()) {
    on<OtpRequested>(_onOtpRequested);
    on<OtpCodeChanged>(_onOtpCodeChanged);
    on<OtpCodeCompleted>(_onOtpCodeCompleted);
    on<ResendOtpDurationFinished>(_onResendOtpDurationFinished);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<ValidateOtpRequested>(_onValidateOtpRequested);
    on<VerifyOtpFailed>(_onVerifyOtpFailed);
    on<OtpFieldTapped>(_onOtpFieldTapped);
  }

  Future<void> _onOtpRequested(
    OtpRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(
      status: OtpStatus.otpRequested,
      emailId: event.emailId,
      resendOtpEnabled: false,
      otpResendDuration: event.otpExpireDuration,
    ));
  }

  Future<void> _onOtpCodeChanged(
    OtpCodeChanged event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(
      status: event.otpCode.length == otpLength
          ? OtpStatus.otpCodeCompleted
          : OtpStatus.unknown,
    ));
  }

  Future<void> _onOtpCodeCompleted(
    OtpCodeCompleted event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(
      status: OtpStatus.otpCodeCompleted,
      otpCode: event.otpCode,
    ));
  }

  Future<void> _onResendOtpDurationFinished(
    ResendOtpDurationFinished event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(
      resendOtpEnabled: true,
    ));
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(
      status: OtpStatus.resendOtp,
    ));
  }

  Future<void> _onValidateOtpRequested(
    ValidateOtpRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(
      status: OtpStatus.verifyOtp,
    ));
  }

  Future<void> _onVerifyOtpFailed(
    VerifyOtpFailed event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(
      status: OtpStatus.verifyOtpFailed,
    ));
  }

  Future<void> _onOtpFieldTapped(
    OtpFieldTapped event,
    Emitter<OtpState> emit,
  ) async {
    if (state.status == OtpStatus.verifyOtpFailed) {
      emit(state.copyWith(
        status: OtpStatus.otpRequested,
      ));
    }
  }
}
