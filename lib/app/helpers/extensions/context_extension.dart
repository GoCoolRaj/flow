import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/generated/l10n.dart';

extension SnackBarExtension on BuildContext {
  Future<void> showErrorSnackBar(String message) async {
    await _showCustomSnackBar(
      message: message,
      icon: Assets.icons.errorWarning.svg(
        width: 16.25,
        height: 16.25,
        colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
      ),
    );
  }

  Future<void> showSuccessSnackBar(String message) async {
    await _showCustomSnackBar(
      message: message,
      icon: Assets.icons.circleTick.svg(width: 16.25, height: 16.25),
    );
  }

  Future<void> showFavoriteSnackBar(
    String collectionName,
    bool isFavorite,
    VoidCallback? onTap,
  ) async {
    await _showCustomFavoriteSnackBar(
      collectionName: collectionName,
      isFavorite: isFavorite,
      onTap: onTap,
    );
  }

  Future<void> _showCustomSnackBar({
    required String message,
    required Widget icon,
  }) async {
    await Flushbar(
      message: message,
      messageSize: 14,
      flushbarPosition: FlushbarPosition.TOP,
      padding: const EdgeInsets.all(14),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      icon: icon,
      borderColor: const Color(0xFF3D3D3D),
      backgroundColor: const Color(0xFF1A1A1A),
    ).show(this);
  }

  Future<void> _showCustomFavoriteSnackBar({
    required String collectionName,
    required bool isFavorite,
    VoidCallback? onTap,
  }) async {
    bool isHiding = false;
    await Flushbar(
      messageText: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  isFavorite ? S().s_saved_to : S().s_removed_from,
                  style: QuiltTheme.snackBarTitleText,
                ),
                Text(collectionName, style: QuiltTheme.snackBarHeaderText),
              ],
            ),
            isFavorite
                ? InkWell(
                    onTap: () {
                      if (!isHiding) {
                        Navigator.of(this).pop();
                      }
                      onTap?.call();
                    },
                    child: Text(
                      S.of(this).s_change,
                      style: QuiltTheme.snackBarChangeText,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      onStatusChanged: (status) {
        isHiding =
            (status == FlushbarStatus.IS_HIDING) ||
            (status == FlushbarStatus.DISMISSED);
      },
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(28),
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(this);
  }
}

extension LocaleExtension on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}
