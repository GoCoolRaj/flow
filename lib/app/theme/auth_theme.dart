import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';

class AuthTheme {
  // OTP Colors
  static const Color otpTextEnabledColor = Colors.white;
  static const Color otpDefaultBorderColor = Color(0xFF3D3D3D);
  static const Color otpFocusedBorderColor = Color(0xFF40A1FB);
  static const Color otpErrorBorderColor = Color(0xFF8A2A2A);
  static const Color otpErrorTextColor = Color(0xFFC84040);

  // OTP Background Colors
  static const Color otpDefaultBackgroundColor = Color(0xFF272727);
  static const Color otpFocusedBackgroundColor = Color(0xFF272727);
  static const Color otpSubmittedBackgroundColor = Color(0xFF272727);
  static const Color otpErrorBackgroundColor = Color(0x4DFF3737);
  static const Color otpResendDisabledBackgroundColor = Color(0xFF272727);

  //* -------------------- OTP Text Styles -------------------- */

  static TextStyle get otpCheckYourEmail => TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get otpEnterTheCode => TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: otpTextEnabledColor.withValues(alpha: 0.75),
  );

  static TextStyle get otpResend =>
      otpEnterTheCode.copyWith(color: otpTextEnabledColor);

  //* -------------------- OTP Pin Themes -------------------- */
  static const double otpWidth = 48;
  static const double otpHeight = 48;
  static const double otpBorderWidth = 1.0;
  static const double otpFocusedBorderWidth = 1.5;
  static const double otpErrorBorderWidth = 2.0;
  static const double otpBorderRadius = 12;

  static const TextStyle otpFieldText = TextStyle(
    fontFamily: 'Causten',
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle otpFieldErrorText = TextStyle(
    fontFamily: 'Causten',
    fontSize: 14,
    color: Colors.red,
    fontWeight: FontWeight.w500,
  );

  static final PinTheme otpDefaultPinTheme = PinTheme(
    width: otpWidth,
    height: otpHeight,
    textStyle: otpFieldText,
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(otpBorderRadius),
      border: Border.all(color: const Color(0xff2C2C2E), width: otpBorderWidth),
    ),
  );

  static final PinTheme otpFocusedPinTheme = otpDefaultPinTheme.copyWith(
    decoration: otpDefaultPinTheme.decoration?.copyWith(
      color: Colors.transparent,
      border: Border.all(
        color: const Color(0xFF7316D0),
        width: otpFocusedBorderWidth,
      ),
      boxShadow: [
        const BoxShadow(
          color: Colors.transparent,
          spreadRadius: 2,
          blurRadius: 4,
        ),
      ],
    ),
  );

  static final PinTheme otpSubmittedPinTheme = otpDefaultPinTheme.copyWith(
    decoration: otpDefaultPinTheme.decoration?.copyWith(
      color: Colors.transparent,
    ),
  );

  static final PinTheme otpErrorPinTheme = otpDefaultPinTheme.copyWith(
    decoration: otpDefaultPinTheme.decoration?.copyWith(
      color: Colors.transparent,
      border: Border.all(
        color: otpErrorBorderColor,
        width: otpErrorBorderWidth,
      ),
    ),
  );

  static const TextStyle profileTitle = TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get profileSubtitle => TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white.withValues(alpha: 0.7),
  );

  static const TextStyle profileLabel = TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle profileInputText = TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const TextStyle profileHintText = TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: QuiltTheme.labelSecondary,
  );

  static const TextStyle profileChipText = TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle profileSkipText = TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle get profileStepText => TextStyle(
    fontFamily: QuiltTheme.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white.withValues(alpha: 0.7),
  );

  static BoxDecoration profileFieldOuterDecoration({
    double radius = 30,
    bool isFocused = false,
  }) {
    return BoxDecoration(
      gradient: isFocused ? QuiltTheme.quiltGradient : null,
      border: isFocused
          ? null
          : Border.all(color: const Color(0xFF3D3D3D)),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration profileFieldInnerDecoration({double radius = 30}) =>
      BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(radius),
      );

  static InputDecoration profileInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: profileHintText,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 18,
      ),
    );
  }
}
