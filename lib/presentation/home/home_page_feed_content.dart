import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_bloc.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';
import 'package:readmore/readmore.dart';

class HomePageFeedContent<T extends FeedBloc> extends StatelessWidget {
  final FeedScope feedScope;
  final FeedBloc feedBloc;
  final ContentItem contentItem;

  const HomePageFeedContent({
    super.key,
    required this.feedScope,
    required this.feedBloc,
    required this.contentItem,
  });

  @override
  Widget build(BuildContext context) {
    Content content = contentItem.content;
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 12, bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GestureDetector(
              //   onTap: () {
              //     final userId = contentItem.userId;
              //     if (userId == null || userId.isEmpty) {
              //       return;
              //     }
              //     final sessionBloc = GetIt.I<SessionBloc>();
              //     final sessionState = sessionBloc.state;

              //     final generatedUserId = SessionBloc.generateIncrementedUserId(
              //         sessionState.userIdMap, userId);

              //     sessionBloc.add(AddUserIdEntry(
              //       userId: userId,
              //       userSessionId: generatedUserId,
              //     ));

              //     context.pushNamed(MainRouter.profileRoute, queryParameters: {
              //       MainRouter.profileUserIdParamKey: userId,
              //       MainRouter.generatedUserIdParamKey: generatedUserId
              //     });
              //     return;
              //   },
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       badges.Badge(
              //         showBadge: content.isFollowed,
              //         position:
              //             badges.BadgePosition.bottomEnd(bottom: 0, end: 0),
              //         badgeStyle: const badges.BadgeStyle(
              //           shape: badges.BadgeShape.circle,
              //           badgeColor: Colors.white,
              //           padding: EdgeInsets.all(2),
              //         ),
              //         badgeContent: Assets.icons.simpleTick.svg(),
              //         child: ClipOval(
              //           child: ProfileCachedImageShimmer(
              //             imageUrl: content.profilePicture,
              //             width: 33,
              //             height: 33,
              //             name: content.userName,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 6),
              //       Flexible(
              //         child: Text(
              //           content.userName,
              //           maxLines: 1,
              //           overflow: TextOverflow.ellipsis,
              //           softWrap: false,
              //           style: QuiltTheme.simpleWhiteTextStyle.copyWith(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 16,
              //             color: Colors.white,
              //           ),
              //           strutStyle: const StrutStyle(
              //             height: 1,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 14),
              //       ConditionalWidget(
              //         condition: !content.isFollowed &&
              //             contentItem.userId != null &&
              //             contentItem.userId!.isNotEmpty &&
              //             contentItem.userId !=
              //                 GetIt.I
              //                     .get<HiveManager>()
              //                     .getFromHive(HiveManager.userIdKey),
              //         onTrue: QuiltButton(
              //           buttonState: ButtonState.enabled,
              //           buttonType: ButtonType.filled,
              //           textString: "Follow",
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 16, vertical: 8),
              //           enabledTextStyle:
              //               QuiltTheme.simpleWhiteTextStyle.copyWith(
              //             fontSize: 16,
              //             color: const Color(0xFF272727),
              //             fontWeight: FontWeight.w500,
              //           ),
              //           onPressed: (p0) {
              //             if (contentItem.userId != null &&
              //                 contentItem.userId!.isNotEmpty) {
              //               feedBloc
              //                   .add(FollowUser(userId: contentItem.userId!));
              //             }
              //           },
              //         ),
              //         onFalse: const SizedBox.shrink(),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 8),
              if (content.description.isNotEmpty)
                AnimatedSize(
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.easeInOut,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: content.description.length > 28
                          ? 120
                          : double.infinity,
                    ),
                    child: ReadMoreText(
                      content.description,
                      trimMode: TrimMode.Length,
                      trimLength: 28,
                      style: QuiltTheme.homePageContentInfoHashtagTextStyle,
                      trimCollapsedText: '  show more',
                      trimExpandedText: '  show less',
                      moreStyle: QuiltTheme.simpleWhiteTextStyle.copyWith(
                        color: QuiltTheme.homeOverlayWhite,
                      ),
                      lessStyle: QuiltTheme.simpleWhiteTextStyle.copyWith(
                        color: QuiltTheme.homeOverlayWhite,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
