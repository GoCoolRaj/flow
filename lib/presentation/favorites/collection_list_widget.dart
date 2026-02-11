import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/generated/l10n.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_state.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_list_item_widget.dart';

class CollectionListWidget extends StatelessWidget {
  final VoidCallback onNewCollection;
  const CollectionListWidget({super.key, required this.onNewCollection});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final collections = state.collections
            .where((collection) => !(collection.isFavorite ?? false))
            .toList();
        final favoritedCollection = state.collections.isNotEmpty
            ? state.collections.lastWhere(
                (collection) => collection.isFavorite ?? false,
                orElse: () => state.collections.first,
              )
            : null;
        final maxHeight = MediaQuery.of(context).size.height * 0.8;
        var itemHeight = 50.0;
        if (Platform.isIOS) {
          itemHeight = 65.0;
          if (collections.isEmpty) {
            itemHeight = 80.0;
          }
        }
        const bottomSectionHeight = 140.0;
        final totalContentHeight =
            (collections.length + 1) * itemHeight + bottomSectionHeight;

        return Container(
          constraints: BoxConstraints(
            maxHeight: totalContentHeight > maxHeight
                ? maxHeight
                : totalContentHeight,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      CollectionListItem(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Assets.icons.favoriteQuickSaveIcon.svg(),
                        ),
                        title: favoritedCollection?.collectionName ?? "",
                        subtitle: S.of(context).s_quick_save,
                        isFavorite: true,
                      ),
                      ...collections.map(
                        (collection) => CollectionListItem(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[800],
                            child: Assets.icons.favoriteDefaultIcon.svg(),
                          ),
                          title: collection.collectionName!,
                          subtitle:
                              '${collection.collectionCount!} experiences',
                          onTap: () {
                            context.read<FavoritesBloc>().add(
                              ToggleFavorite(
                                collectionId: collection.collectionId!,
                                isFavorite: true,
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CollectionListItem(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Assets.icons.addIcon.svg(),
                      ),
                      title: S.of(context).s_new_collection,
                      isShowBookmarkIcon: false,
                      onTap: onNewCollection,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: QuiltButton(
                        buttonType: ButtonType.filled,
                        enabledTextStyle: QuiltTheme.dialogMessageStyle
                            .copyWith(color: Colors.white),
                        enabledButtonFilledStyle: QuiltTheme
                            .createProfileButtonEnabledFilled
                            .copyWith(color: QuiltTheme.otpDefaultBorderColor),
                        textString: S.of(context).s_close,
                        onPressed: (value) => Navigator.pop(context),
                        buttonState: ButtonState.enabled,
                        expandButton: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
