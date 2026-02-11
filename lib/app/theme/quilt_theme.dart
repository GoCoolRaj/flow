import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quilt_flow_app/generated/fonts.gen.dart';

class QuiltTheme {
  static const Color quiltTextColor = Color(0xFFFFFFFF);

  static const Color labelSecondary = Color(0x993C3C43);

  //* -------------------- Color Palette -------------------- */
  static const Color primaryColor = Color(0xFF1A1A1A);
  static const Color secondaryColor = Colors.white;
  static const Color tertiaryColor = Color(0xFF40A1FB);
  static const Color dialogBackgroundColor = Colors.black;
  static const Color homeBottomSheetBackground = Color(0xFF131314);
  static const Color homeBottomSheetBorder = Color(0x33000000);
  static const Color shimmerBaseColor = Color(0xFF272727);
  static const Color shimmerHighlightColor = Color(0xFF212121);
  static const Color shimmerSurfaceColor = Colors.white;
  static const Color shimmerBaseLight = Color(0xFF90A4AE);
  static const Color shimmerHighlightLight = Color(0xFFCFD8DC);
  static const Color homeOverlayWhite = Color(0x66FFFFFF);
  static const Color sessionCompletedTitleColor = Color(0xFFD1D5DC);
  static const Color sessionCompletedSubtitleColor = Color(0xFF6A7282);
  static const Color profileInitialBackgroundColor = Colors.black;
  static const Color otpDefaultBorderColor = Color(0xFF3D3D3D);
  static const Color otpErrorTextColor = Color(0xFFC84040);
  static const Color iconDefaultColor = Colors.white;
  static const Color iconSelectedColor = Colors.blue;
  static const Color iconDisabledColor = Colors.grey;
  static const Color iconAccentColor = Colors.green;
  static const Color actionDestructiveColor = Colors.red;
  static const Color dialogPositiveTextColor = tertiaryColor;
  static const Color labelTextColor = secondaryLabelColor;

  //* -------------------- Label Colors -------------------- */
  static const Color primaryLabelColor = Color(0xFFFFFFFF);
  static const Color secondaryLabelColor = Color(0x99EBEBF5);
  static const Color tertiaryLabelColor = Color(0x4DEBEBF5);

  static const String fontFamily = 'Outfit';

  static const LinearGradient quiltGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7316D0), Color(0xFF8C00E2), Color(0xFF5021FB)],
    stops: [0.0, 0.2692, 1.0],
  );

  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(30),
  );

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: FontFamily.outfit,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
    );
  }

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: quiltTextColor,
  );

  static const TextStyle dialogTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle dialogMessageStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: secondaryLabelColor,
  );

  static const TextStyle snackBarTitleText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle snackBarHeaderText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle snackBarChangeText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle mediaScreenDurationText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: secondaryLabelColor,
  );

  static const TextStyle disclaimerHeaderText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle settingInfoText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: secondaryLabelColor,
  );

  static const TextStyle profileUserNameText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle profileAddText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: secondaryLabelColor,
  );

  static const TextStyle openFeedbackStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle likeCountText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle favoriteCountText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle homePageContentInfoHashtagTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const Color genderInfoTextColor = Color(0xFF6A7282);

  static const TextStyle imageSelectionDialogText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle promptTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const TextStyle openFeedbackText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: secondaryLabelColor,
  );

  static const TextStyle textEnabledTheme = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle textFieldText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle textFieldHintText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: secondaryLabelColor,
  );

  static BoxDecoration get openFeedbackButtonDisabledFilled => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.12),
    borderRadius: buttonRadius,
  );

  static const TextStyle openFeedbackButtonDisabledText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: secondaryLabelColor,
  );

  static TextStyle _baseTextStyle(
    Color color,
    double fontSize,
    FontWeight fontWeight,
  ) {
    return TextStyle(
      fontFamily: FontFamily.outfit,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle get simpleBlackTextStyle =>
      _baseTextStyle(primaryColor, 14, FontWeight.normal);

  static TextStyle get simpleWhiteTextStyle =>
      _baseTextStyle(Colors.white, 14, FontWeight.normal);

  static BoxDecoration get buttonEnabledFilled =>
      BoxDecoration(gradient: quiltGradient, borderRadius: buttonRadius);

  static BoxDecoration get buttonDisabledFilled =>
      BoxDecoration(color: const Color(0xFF3D3D3D), borderRadius: buttonRadius);

  static BoxDecoration get buttonCompletedFilled =>
      BoxDecoration(gradient: quiltGradient, borderRadius: buttonRadius);

  static BoxDecoration get buttonCompletedFilledFabric =>
      BoxDecoration(gradient: quiltGradient, borderRadius: buttonRadius);

  static BoxDecoration get buttonEnabledOutlined => BoxDecoration(
    color: Colors.transparent,
    borderRadius: buttonRadius,
    border: Border.all(color: const Color(0xFF7316D0), width: 1.2),
  );

  static BoxDecoration get buttonDisabledOutlined => BoxDecoration(
    color: Colors.transparent,
    borderRadius: buttonRadius,
    border: Border.all(
      color: const Color(0xFF7316D0).withValues(alpha: 0.45),
      width: 1.2,
    ),
  );

  static BoxDecoration get buttonCompletedOutlined => BoxDecoration(
    color: Colors.transparent,
    borderRadius: buttonRadius,
    border: Border.all(color: const Color(0xFF7316D0), width: 1.2),
  );

  static BoxDecoration get dialogCompletedFilled =>
      BoxDecoration(gradient: quiltGradient, borderRadius: buttonRadius);

  static BoxDecoration get createProfileButtonEnabledFilled => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.12),
    borderRadius: buttonRadius,
  );

  static BoxDecoration get signoutEnabledFilled =>
      BoxDecoration(color: Colors.white, borderRadius: buttonRadius);

  static const InputDecoration updateProfileFieldEnabled = InputDecoration(
    filled: false,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF7316D0), width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF7316D0), width: 1.2),
    ),
  );

  static const InputDecoration filledEnabled = InputDecoration(
    filled: true,
    fillColor: Color(0xFF1C1C1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF2C2C2E), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF2C2C2E), width: 1),
    ),
  );

  static const InputDecoration filledDisabled = InputDecoration(
    filled: true,
    fillColor: Color(0xFF1C1C1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF3A3A3C), width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF3A3A3C), width: 1),
    ),
  );

  static const InputDecoration filledFocused = InputDecoration(
    filled: true,
    fillColor: Color(0xFF1C1C1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF7316D0), width: 1.4),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF7316D0), width: 1.4),
    ),
  );

  static const InputDecoration outlinedEnabled = InputDecoration(
    filled: false,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF2C2C2E), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF2C2C2E), width: 1),
    ),
  );

  static const InputDecoration outlinedDisabled = InputDecoration(
    filled: false,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF3A3A3C), width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF3A3A3C), width: 1),
    ),
  );

  static const InputDecoration outlinedFocused = InputDecoration(
    filled: false,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF7316D0), width: 1.4),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF7316D0), width: 1.4),
    ),
  );

  static const InputDecoration underlinedEnabled = InputDecoration(
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2C2C2E), width: 1),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2C2C2E), width: 1),
    ),
  );

  static const InputDecoration underlinedDisabled = InputDecoration(
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF3A3A3C), width: 1),
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF3A3A3C), width: 1),
    ),
  );

  static const InputDecoration underlinedFocused = InputDecoration(
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF7316D0), width: 1.4),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF7316D0), width: 1.4),
    ),
  );

  static BoxDecoration get logoutButtonEnabledFilled =>
      BoxDecoration(color: Colors.white, borderRadius: buttonRadius);

  static BoxDecoration get logoutNegativeButtonEnabledFilled =>
      BoxDecoration(color: Colors.transparent, borderRadius: buttonRadius);

  static const Color createProfileSaveTextColor = Color(0xFFFFFFFF);

  static const LinearGradient feedOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Colors.transparent,
      Color.fromRGBO(0, 0, 0, 0.2),
      Color.fromRGBO(0, 0, 0, 0.5),
      Colors.transparent,
    ],
    stops: [0.0, 0.7, 0.75, 0.85, 1.0],
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
  );
}
