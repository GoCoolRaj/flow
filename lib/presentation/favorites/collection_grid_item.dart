import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_grid.dart';
import 'package:quilt_flow_app/presentation/main_router.dart';

class CollectionGridItem extends StatelessWidget {
  final CollectionObject collection;
  const CollectionGridItem({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final experienceCount = collection.collectionCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            child: CollectionGrid(experienceCount: experienceCount!),
            onTap: () {
              context.read<FavoritesBloc>().add(
                GetFavoriteList(
                  collectionId: collection.collectionId,
                  pageSize: 1,
                  collectionName: collection.collectionName,
                  favorites: const [],
                ),
              );
              context.pushNamed(MainRouter.favoriteRoute);
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.collectionName ?? '',
                      style: QuiltTheme.disclaimerHeaderText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$experienceCount experiences',
                      style: QuiltTheme.favoriteCountText,
                    ),
                  ],
                ),
              ),
              /* Icon(
                Icons.more_horiz,
                color: Colors.grey[400],
                size: 20,
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
