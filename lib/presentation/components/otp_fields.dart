import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';

class OtpFields extends StatelessWidget {
  final int length;
  final bool obscureText;
  final String? value;
  final bool forceError;
  final bool isAnimateFields;
  final bool isAnimateError;
  final Widget? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final Function() onTap;
  final TextEditingController controller;
  final FocusNode? focusNode;

  final PinTheme? customDefaultPinTheme;
  final PinTheme? customFocusedPinTheme;
  final PinTheme? customSubmittedPinTheme;
  final PinTheme? customErrorPinTheme;

  const OtpFields({
    super.key,
    required this.length,
    this.obscureText = false,
    this.value,
    this.forceError = false,
    this.isAnimateFields = true,
    this.isAnimateError = true,
    this.placeholder,
    this.onChanged,
    this.onCompleted,
    required this.onTap,
    required this.controller,
    this.focusNode,
    this.customDefaultPinTheme,
    this.customFocusedPinTheme,
    this.customSubmittedPinTheme,
    this.customErrorPinTheme,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme =
        customDefaultPinTheme ?? AuthTheme.otpDefaultPinTheme;
    final focusedPinTheme =
        customFocusedPinTheme ?? AuthTheme.otpFocusedPinTheme;
    final submittedPinTheme =
        customSubmittedPinTheme ?? AuthTheme.otpSubmittedPinTheme;
    final errorPinTheme = customErrorPinTheme ?? AuthTheme.otpErrorPinTheme;

    return Pinput(
      length: length,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 8),
      onTap: onTap,
      onCompleted: (pin) {
        onCompleted?.call(pin);
      },
      onChanged: (value) {
        onChanged?.call(value);
      },
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
      autofocus: false,
      errorText: "Invalid OTP",

      forceErrorState: forceError,
      pinAnimationType: PinAnimationType.scale,
      closeKeyboardWhenCompleted: false,
    );
  }
}
