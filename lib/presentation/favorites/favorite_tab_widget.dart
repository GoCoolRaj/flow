import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/generated/l10n.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_state.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_grid_item.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_list_item_widget.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_view_widget.dart';

class FavoritesTabWidget extends StatelessWidget {
  const FavoritesTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: CollectionListItem(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Assets.icons.addIcon.svg(),
                ),
                title: S.of(context).s_new_collection,
                isShowBookmarkIcon: false,
                onTap: () {
                  context.read<FavoritesBloc>().add(
                    ToggleNewCollectionCreateView(true),
                  );
                  CollectionsViewWidget.show(context);
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                key: const PageStorageKey('favorites_tab'),
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: state.collections.length,
                itemBuilder: (context, index) {
                  return CollectionGridItem(
                    collection: state.collections[index],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
