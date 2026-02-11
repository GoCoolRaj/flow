import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_event.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_state.dart';
import 'package:quilt_flow_app/presentation/components/conditional_widget.dart';
import 'package:quilt_flow_app/presentation/components/otp_fields.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with WidgetsBindingObserver {
  final _otpTextController = TextEditingController();
  final _otpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _otpFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: SizedBox(
            height: 15,
            width: 15,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Assets.icons.appbarBack.svg(fit: BoxFit.contain),
            ),
          ),
        ),
        shadowColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                Text("Check your email", style: AuthTheme.otpCheckYourEmail),
                const SizedBox(height: 12),
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Enter the OTP sent to",
                          style: AuthTheme.otpEnterTheCode,
                        ),
                        Text(
                          state.emailId,
                          style: AuthTheme.otpEnterTheCode.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocConsumer<OtpBloc, OtpState>(
                  listenWhen: (previous, current) {
                    return previous.status != current.status &&
                        current.status == OtpStatus.otpRequested;
                  },
                  listener: (context, state) {
                    _otpTextController.clear();
                    _otpFocusNode.requestFocus();
                  },
                  builder: (context, state) {
                    return OtpFields(
                      length: 4,
                      controller: _otpTextController,
                      focusNode: _otpFocusNode,
                      isAnimateError: true,
                      isAnimateFields: false,
                      customDefaultPinTheme: AuthTheme.otpDefaultPinTheme,
                      customFocusedPinTheme: AuthTheme.otpFocusedPinTheme,
                      customSubmittedPinTheme: AuthTheme.otpSubmittedPinTheme,
                      customErrorPinTheme: AuthTheme.otpErrorPinTheme,
                      onTap: () {
                        context.read<OtpBloc>().add(const OtpFieldTapped());
                      },
                      onChanged: (value) {
                        context.read<OtpBloc>().add(OtpCodeChanged(value));
                      },
                      onCompleted: (value) {
                        context.read<OtpBloc>().add(
                          OtpCodeCompleted(int.parse(value)),
                        );
                      },
                      forceError: state.status == OtpStatus.verifyOtpFailed,
                    );
                  },
                ),
                const SizedBox(height: 42),
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    return ConditionalWidget(
                      condition: state.resendOtpEnabled,
                      onTrue: QuiltButton(
                        buttonType: ButtonType.filled,
                        completedTextStyle: AuthTheme.otpResend,
                        textString: "resend OTP",
                        buttonState: ButtonState.completed,
                        completedButtonFilledStyle:
                            QuiltTheme.buttonCompletedFilled,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
                        onPressed: (value) {
                          context.read<OtpBloc>().add(
                            const ResendOtpRequested(),
                          );
                        },
                      ),
                      onFalse: Countdown(
                        seconds: state.otpResendDuration,
                        build: (context, time) {
                          final int totalSeconds = time.round();
                          final int minutes = totalSeconds ~/ 60;
                          final int seconds = totalSeconds % 60;
                          final String mm = minutes < 10
                              ? '0$minutes'
                              : '$minutes';
                          final String ss = seconds < 10
                              ? '0$seconds'
                              : '$seconds';
                          return QuiltButton(
                            buttonType: ButtonType.filled,
                            disabledTextStyle: AuthTheme.otpResend,
                            disabledButtonFilledStyle: QuiltTheme
                                .buttonDisabledFilled
                                .copyWith(
                                  color: AuthTheme
                                      .otpResendDisabledBackgroundColor,
                                ),
                            textString: "OTP resend in $mm:$ss",
                            buttonState: ButtonState.disabled,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 6,
                            ),
                          );
                        },
                        onFinished: () {
                          context.read<OtpBloc>().add(
                            const ResendOtpDurationFinished(),
                          );
                        },
                      ),
                    );
                  },
                ),
                const Spacer(),
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    return QuiltButton(
                      textString: "Confirm Email",
                      buttonType: ButtonType.filled,
                      buttonState: state.status == OtpStatus.otpCodeCompleted
                          ? ButtonState.completed
                          : ButtonState.disabled,
                      completedTextStyle: QuiltTheme.buttonText.copyWith(
                        color: Colors.white,
                      ),
                      completedButtonFilledStyle:
                          QuiltTheme.buttonCompletedFilled,
                      expandButton: true,
                      onPressed: (value) {
                        _otpFocusNode.unfocus();
                        context.read<OtpBloc>().add(
                          const ValidateOtpRequested(),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _otpFocusNode.requestFocus();
      SystemChannels.textInput.invokeMethod('TextInput.show');
    }
  }

  @override
  void dispose() {
    _otpTextController.dispose();
    _otpFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
