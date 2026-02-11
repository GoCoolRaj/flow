import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/domain/home/model/content_flavours.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/main_router.dart';

class FavoriteListItem extends StatefulWidget {
  final ContentItem contentItem;
  const FavoriteListItem({super.key, required this.contentItem});
  @override
  State<FavoriteListItem> createState() => _FavoriteListItemState();
}

class _FavoriteListItemState extends State<FavoriteListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      excludeFromSemantics: true,
      canRequestFocus: false,
      enableFeedback: false,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        if (widget.contentItem.content.contentFormat == ContentFormat.VIDEO) {
          context.pushNamed(
            MainRouter.mediaRoute,
            extra: {"content": widget.contentItem},
          );
        }
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: 1.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: 1.0,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: QuiltTheme.otpDefaultBorderColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.contentItem.content.thumbnailUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Assets.icons.userContentEmptyImage.svg(),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contentItem.content.description,
                      style: QuiltTheme.disclaimerHeaderText,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: QuiltTheme.tertiaryColor.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 12,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.bookmark,
                      color: QuiltTheme.tertiaryColor,
                      size: 22,
                    ),
                  ],
                ),
                onPressed: () {
                  context.read<FavoritesBloc>().add(
                    UserFavoriteEvent(
                      isFavorite: false,
                      contentId: widget.contentItem.content.id,
                      isShowLoading: true,
                      collectionId: context
                          .read<FavoritesBloc>()
                          .state
                          .collectionId!,
                      isUpdatedFromFavoriteList: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
