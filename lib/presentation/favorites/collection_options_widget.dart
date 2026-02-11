import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/generated/l10n.dart';
import 'package:quilt_flow_app/presentation/components/quilt_dialog.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_view_widget.dart';

class FavoriteListOptionsWidget extends StatelessWidget {
  final String? title;
  const FavoriteListOptionsWidget({super.key, this.title});

  static void show(BuildContext context, String title) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      isDismissible: true,
      enableDrag: true,
      builder: (_) => FavoriteListOptionsWidget(title: title),
    );
  }

  Widget _buildOptionItem({
    required SvgGenImage icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
    TextStyle? textStyle,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            icon.svg(
              colorFilter: ColorFilter.mode(
                iconColor ?? Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 15),
            Text(text, style: textStyle),
          ],
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, String title) {
    QuiltDialog(
      infoImage: Assets.icons.delete.svg(height: 23, width: 23),
      type: QuiltDialogType.custom,
      customConfirmText: S.of(context).s_delete,
      customTitle: title,
      customCancelText: S.of(context).s_cancel,
      customMessage: S.of(context).s_collection_delete_message,
      confirmButtonDecoration: QuiltTheme.signoutEnabledFilled,
      negativeButtonDecoration: QuiltTheme.signoutEnabledFilled,
      negativeTextStyle: QuiltTheme.openFeedbackStyle.copyWith(
        color: Colors.white,
      ),
      confirmTextStyle: QuiltTheme.openFeedbackStyle.copyWith(
        color: QuiltTheme.dialogPositiveTextColor,
      ),
      onConfirm: () {
        GetIt.I<FavoritesBloc>().add(
          DeleteCollection(GetIt.I<FavoritesBloc>().state.collectionId!),
        );
      },
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            _buildOptionItem(
              icon: Assets.icons.collectionEdit,
              text: S.of(context).s_rename,
              iconColor: QuiltTheme.genderInfoTextColor,
              onTap: () {
                Navigator.of(context).pop();
                GetIt.I<FavoritesBloc>().add(ToggleUpdateView(true));
                CollectionsViewWidget.show(context);
              },
              textStyle: QuiltTheme.disclaimerHeaderText,
            ),
            _buildOptionItem(
              icon: Assets.icons.deleteIcon,
              text: S.of(context).s_delete_collection,
              onTap: () => {
                Navigator.pop(context),
                showDeleteDialog(
                  context,
                  "${S.of(context).s_delete_collection}\n$title",
                ),
              },
              textStyle: QuiltTheme.disclaimerHeaderText.copyWith(
                color: QuiltTheme.otpErrorTextColor,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
