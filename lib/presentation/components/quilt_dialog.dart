import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/generated/l10n.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';

enum QuiltDialogType {
  logout,
  openFeedback,
  custom,
  deleteAccount;

  String getTitle(S l10n) {
    switch (this) {
      case QuiltDialogType.logout:
        return l10n.s_logout_title;
      case QuiltDialogType.openFeedback:
        return l10n.thanks_for_feedback;
      case QuiltDialogType.custom:
        return "";
      case QuiltDialogType.deleteAccount:
        return l10n.delete_account;
    }
  }

  String getMessage(S l10n) {
    switch (this) {
      case QuiltDialogType.logout:
        return "";
      case QuiltDialogType.openFeedback:
        return l10n.thanks_for_feedback_desc;
      case QuiltDialogType.custom:
        return "";
      case QuiltDialogType.deleteAccount:
        return l10n.delete_account_hint;
    }
  }

  String getConfirmText(S l10n) {
    switch (this) {
      case QuiltDialogType.logout:
        return l10n.s_yes;
      case QuiltDialogType.openFeedback:
        return l10n.s_okay;
      case QuiltDialogType.custom:
        return l10n.s_yes;
      case QuiltDialogType.deleteAccount:
        return "Continue";
    }
  }

  String getNegativeText(S l10n) {
    switch (this) {
      case QuiltDialogType.logout:
        return l10n.s_no;
      case QuiltDialogType.openFeedback:
        return "";
      case QuiltDialogType.custom:
        return l10n.s_no;
      case QuiltDialogType.deleteAccount:
        return "Cancel";
    }
  }
}

class QuiltDialog extends StatelessWidget {
  final QuiltDialogType type;
  final String? customTitle;
  final BoxDecoration? confirmButtonDecoration;
  final BoxDecoration? negativeButtonDecoration;
  final TextStyle? confirmTextStyle;
  final TextStyle? negativeTextStyle;
  final String? customMessage;
  final String? customConfirmText;
  final String? customCancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool barrierDismissible;
  final Widget? infoImage;

  const QuiltDialog({
    super.key,
    required this.type,
    this.customTitle,
    this.customCancelText,
    this.customMessage,
    this.customConfirmText,
    this.onConfirm,
    this.onCancel,
    this.confirmButtonDecoration,
    this.negativeButtonDecoration,
    this.confirmTextStyle,
    this.negativeTextStyle,
    this.infoImage,
    this.barrierDismissible = false,
  });

  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final S l10n = S.of(context);
    return Dialog(
      backgroundColor: QuiltTheme.dialogBackgroundColor,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == QuiltDialogType.openFeedback)
              const SizedBox(height: 20),
            if (type == QuiltDialogType.openFeedback && infoImage == null)
              Container(child: Assets.icons.disclaimerIcon.svg()),
            if (infoImage != null) const SizedBox(height: 10),
            if (infoImage != null) Container(child: infoImage),
            const SizedBox(height: 20),
            Text(
              customTitle ?? type.getTitle(l10n),
              textAlign: TextAlign.center,
              style: QuiltTheme.dialogTitleStyle,
            ),
            const SizedBox(height: 10),
            if (type != QuiltDialogType.logout)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  customMessage ?? type.getMessage(l10n),
                  textAlign: TextAlign.center,
                  style: QuiltTheme.dialogMessageStyle,
                ),
              ),
            const SizedBox(height: 20),
            QuiltButton(
              buttonType: ButtonType.filled,
              enabledButtonFilledStyle:
                  confirmButtonDecoration ??
                  QuiltTheme.logoutButtonEnabledFilled,
              textString: customConfirmText ?? type.getConfirmText(l10n),
              onPressed: (value) {
                Navigator.pop(context);
                onConfirm?.call();
              },
              buttonState: ButtonState.enabled,
              expandButton: true,
              enabledTextStyle:
                  confirmTextStyle ??
                  QuiltTheme.dialogMessageStyle.copyWith(
                    color: QuiltTheme.primaryLabelColor,
                  ),
            ),
            const SizedBox(height: 5),
            if (type != QuiltDialogType.openFeedback)
              QuiltButton(
                buttonType: ButtonType.filled,
                enabledButtonFilledStyle:
                    negativeButtonDecoration ??
                    QuiltTheme.logoutNegativeButtonEnabledFilled,
                textString: customCancelText ?? type.getNegativeText(l10n),
                onPressed: (value) {
                  Navigator.pop(context);
                  onCancel?.call();
                },
                buttonState: ButtonState.enabled,
                expandButton: true,
                enabledTextStyle:
                    negativeTextStyle ??
                    QuiltTheme.dialogMessageStyle.copyWith(
                      color: QuiltTheme.primaryLabelColor,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
