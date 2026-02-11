import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/generated/l10n.dart';
import 'package:quilt_flow_app/presentation/components/icon_list.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_bloc.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_event.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';

class HomePageSideBarSocialActions<T extends FeedBloc> extends StatelessWidget {
  final T feedBloc;
  final Content content;
  final bool isMuted;
  final bool isPaused;
  final String? userId;
  final String? createdUserId;
  final FeedScope feedScope;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onFeedbackPressed;
  final bool showFeedback;

  const HomePageSideBarSocialActions({
    super.key,
    required this.feedBloc,
    required this.content,
    required this.isMuted,
    required this.isPaused,
    required this.userId,
    required this.createdUserId,
    required this.feedScope,
    this.onCommentPressed,
    this.onFeedbackPressed,
    this.showFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconItems = <IconItem>[
      IconItem(
        IconType.sound,
        isMuted ? IconStatus.selected : IconStatus.defaultStatus,
        onTap: (status) {
          feedBloc.add(
            HomeFeedMutePressed(isMuted: !(status == IconStatus.selected)),
          );
        },
      ),
      IconItem(
        IconType.favourites,
        content.isFavourite ? IconStatus.selected : IconStatus.defaultStatus,
        onTap: (status) {
          feedBloc.add(
            HomeFeedFavoritePressed(
              isFavorite: !content.isFavourite,
              id: content.id,
              isUpdateFavorite: true,
              collectionId: content.collectionId,
              feedScope: feedScope,
            ),
          );
        },
      ),
    ];

    if (showFeedback) {
      iconItems.add(
        IconItem(
          IconType.feedback,
          onFeedbackPressed == null
              ? IconStatus.disabled
              : IconStatus.defaultStatus,
          onTap: (_) => onFeedbackPressed?.call(),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: IconList(
            alignment: Alignment.bottomCenter,
            iconItems: iconItems,
            iconPadding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            isVertical: true,
          ),
        ),
      ],
    );
  }

  void showOptionsDialog(
    BuildContext context,
    bool isHome,
    Content content,
    bool? isSelfBlock,
  ) {
    final homeBloc = feedBloc;
    homeBloc.add(const HomeFeedPaused(isUserInitiated: true));
    bool isOpenedReport = false;
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: QuiltTheme.homeBottomSheetBackground,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        side: BorderSide(color: Colors.transparent, width: 0),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext buildContext) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: const BoxDecoration(
              color: QuiltTheme.homeBottomSheetBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            foregroundDecoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              border: Border(
                top: BorderSide(
                  color: QuiltTheme.homeBottomSheetBorder,
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: QuiltTheme.createProfileSaveTextColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    QuiltActionList(
                      padding: EdgeInsets.zero,
                      itemSpacing: 10,
                      itemMargin: const EdgeInsets.symmetric(horizontal: 20),
                      items: [
                        QuiltActionEntry(
                          child: QuiltActionIconLabel(
                            icon: content.isFavourite
                                ? Assets.icons.favouriteSelected.svg(height: 30)
                                : Assets.icons.favourites.svg(height: 30),
                            text: S.of(context).s_save,
                            tone: QuiltActionTone.normal,
                          ),
                          onTap: () {
                            homeBloc.add(
                              HomeFeedFavoritePressed(
                                isFavorite: !content.isFavourite,
                                id: content.id,
                                isUpdateFavorite: true,
                                collectionId: content.collectionId,
                                feedScope: feedScope,
                              ),
                            );
                            Navigator.pop(buildContext, true);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (!isOpenedReport) {
        homeBloc.add(const HomeFeedResumed(isUserInitiated: true));
      }
    });
  }
}

class QuiltActionItemTile extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Decoration? decoration;
  final bool enableInkSplash;
  final double? minHeight;

  const QuiltActionItemTile({
    super.key,
    required this.child,
    required this.onTap,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.decoration,
    this.enableInkSplash = true,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveRadius =
        borderRadius ?? BorderRadius.circular(12);
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 10);
    final Decoration effectiveDecoration =
        decoration ??
        BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: effectiveRadius,
        );
    final content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      child: Container(
        margin: margin,
        decoration: effectiveDecoration,
        child: Padding(padding: effectivePadding, child: child),
      ),
    );
    if (!enableInkSplash) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return Material(
      color: Colors.transparent,
      borderRadius: effectiveRadius,
      child: InkWell(
        borderRadius: effectiveRadius,
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class QuiltActionEntry {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool? enableInkSplash;
  final double? minHeight;

  const QuiltActionEntry({
    required this.child,
    required this.onTap,
    this.margin,
    this.padding,
    this.decoration,
    this.backgroundColor,
    this.borderRadius,
    this.enableInkSplash,
    this.minHeight,
  });
}

class QuiltActionList extends StatelessWidget {
  final List<QuiltActionEntry> items;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? itemPadding;
  final EdgeInsetsGeometry? itemMargin;
  final Decoration? itemDecoration;
  final Color? itemBackgroundColor;
  final BorderRadius? itemBorderRadius;
  final bool enableInkSplash;
  final double? itemMinHeight;
  final bool scrollable;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  const QuiltActionList({
    super.key,
    required this.items,
    this.itemSpacing = 10,
    this.padding = const EdgeInsets.symmetric(vertical: 0),
    this.itemPadding,
    this.itemMargin,
    this.itemDecoration,
    this.itemBackgroundColor,
    this.itemBorderRadius,
    this.enableInkSplash = true,
    this.itemMinHeight,
    this.scrollable = false,
    this.separatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: padding,
      itemBuilder: (context, index) {
        final e = items[index];
        return QuiltActionItemTile(
          onTap: e.onTap,
          margin: e.margin ?? itemMargin,
          padding: e.padding ?? itemPadding,
          decoration: e.decoration ?? itemDecoration,
          backgroundColor: e.backgroundColor ?? itemBackgroundColor,
          borderRadius: e.borderRadius ?? itemBorderRadius,
          enableInkSplash: e.enableInkSplash ?? enableInkSplash,
          minHeight: e.minHeight ?? itemMinHeight,
          child: e.child,
        );
      },
      separatorBuilder: (context, index) =>
          separatorBuilder?.call(context, index) ??
          SizedBox(height: itemSpacing),
      itemCount: items.length,
    );
  }
}

enum QuiltActionTone { normal, destructive }

class QuiltActionIconLabel extends StatelessWidget {
  final Widget icon;
  final String text;
  final QuiltActionTone tone;
  final TextStyle? style;
  final String? secondaryText;
  final TextStyle? secondaryStyle;
  final double spacing;

  const QuiltActionIconLabel({
    super.key,
    required this.icon,
    required this.text,
    this.tone = QuiltActionTone.normal,
    this.style,
    this.secondaryText,
    this.secondaryStyle,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle base = (style ?? QuiltTheme.favoriteCountText).copyWith(
      color: tone == QuiltActionTone.destructive
          ? QuiltTheme.actionDestructiveColor
          : QuiltTheme.primaryLabelColor,
      fontSize: 17,
    );
    final double gap = spacing == 0 ? 10 : spacing;

    final List<Widget> row = [
      icon,
      SizedBox(width: gap),
      if (secondaryText == null)
        Text(text, style: base)
      else
        Row(
          children: [
            Text(text, style: base),
            Text(secondaryText!, style: secondaryStyle ?? base),
          ],
        ),
    ];

    return Row(children: row);
  }
}
