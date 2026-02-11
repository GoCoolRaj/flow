import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/generated/l10n.dart';

class EmptyFavoritesView extends StatelessWidget {
  const EmptyFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.emptyFavoriteBookmark.svg(),
          const SizedBox(height: 16),
          Text(
            S.of(context).s_favorite_empty_info,
            style: QuiltTheme.disclaimerHeaderText,
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).s_favorite_empty_desc,
            textAlign: TextAlign.center,
            style: QuiltTheme.favoriteCountText,
          ),
        ],
      ),
    );
  }
}
