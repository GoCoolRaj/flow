import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';

enum IconType { like, sound, share, feedback, comment, favourites }

enum IconStatus { defaultStatus, selected, disabled }

typedef IconTappedCallback =
    void Function(IconType iconType, IconStatus iconStatus);

class IconItem {
  final IconType type;
  final IconStatus status;
  final String? count;
  final String? contentId;
  final FeedScope? feedScope;
  final void Function(IconStatus status)? onTap;
  IconItem(
    this.type,
    this.status, {
    this.count,
    this.contentId,
    this.feedScope,
    this.onTap,
  });
}

class IconList extends StatelessWidget {
  final List<IconItem> iconItems;
  final bool isVertical;
  final bool endPadding;
  final Color backgroundColor;
  final Alignment alignment;
  final EdgeInsets iconPadding;
  final Color defaultColor;
  final Color selectedColor;
  final Color disabledColor;
  final TextStyle? countTextStyle;

  const IconList({
    super.key,
    required this.iconItems,
    this.isVertical = true,
    this.endPadding = true,
    this.backgroundColor = Colors.transparent,
    this.alignment = Alignment.centerRight,
    this.iconPadding = EdgeInsets.zero,
    this.defaultColor = QuiltTheme.iconDefaultColor,
    this.selectedColor = QuiltTheme.iconSelectedColor,
    this.disabledColor = QuiltTheme.iconDisabledColor,
    this.countTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      widthFactor: 1,
      heightFactor: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: isVertical
            ? Column(mainAxisSize: MainAxisSize.min, children: _buildIconList())
            : Row(mainAxisSize: MainAxisSize.min, children: _buildIconList()),
      ),
    );
  }

  List<Widget> _buildIconList() {
    final padding = iconPadding != EdgeInsets.zero
        ? iconPadding
        : (isVertical ? const EdgeInsets.all(16) : const EdgeInsets.all(16));

    return iconItems.asMap().entries.map((entry) {
      final iconItem = entry.value;

      return AbsorbPointer(
        absorbing: false,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: iconItem.status != IconStatus.disabled
              ? () => iconItem.onTap?.call(iconItem.status)
              : null,
          onDoubleTap: () {},
          child: Padding(
            padding: padding,
            child: Column(
              children: [
                _buildAnimatedIcon(iconItem),
                if (iconItem.count != null &&
                    iconItem.count != '' &&
                    iconItem.count != '0')
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      iconItem.count!,
                      style: countTextStyle ?? QuiltTheme.likeCountText,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAnimatedIcon(IconItem item) {
    ColorFilter colorFilter;
    switch (item.status) {
      case IconStatus.defaultStatus:
        colorFilter = ColorFilter.mode(defaultColor, BlendMode.srcIn);
        break;
      case IconStatus.selected:
        colorFilter = ColorFilter.mode(selectedColor, BlendMode.srcIn);
        break;
      case IconStatus.disabled:
        colorFilter = ColorFilter.mode(disabledColor, BlendMode.srcIn);
        break;
    }

    final iconMap = {
      IconType.sound: {
        IconStatus.defaultStatus: Assets.icons.soundUnmute.svg(),
        IconStatus.selected: Assets.icons.soundMute.svg(),
        IconStatus.disabled: Assets.icons.soundUnmute.svg(),
      },
      IconType.favourites: {
        IconStatus.defaultStatus: Assets.icons.favourites.svg(),
        IconStatus.selected: Assets.icons.favouriteSelected.svg(),
        IconStatus.disabled: Assets.icons.favourites.svg(),
      },
        IconType.share: {
          IconStatus.defaultStatus: Assets.icons.share.svg(
            colorFilter: colorFilter,
          ),
          IconStatus.selected: Assets.icons.share.svg(
            colorFilter: const ColorFilter.mode(
              QuiltTheme.iconAccentColor,
              BlendMode.srcIn,
            ),
          ),
          IconStatus.disabled: Assets.icons.share.svg(colorFilter: colorFilter),
        },
      IconType.feedback: {
        IconStatus.defaultStatus: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.white),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Assets.icons.lightBulb.svg(colorFilter: colorFilter),
        ),
        IconStatus.selected: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.white),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Assets.icons.lightBulb.svg(
            colorFilter: const ColorFilter.mode(
              QuiltTheme.iconAccentColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        IconStatus.disabled: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(color: Colors.white),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Assets.icons.lightBulb.svg(colorFilter: colorFilter),
        ),
      },
    };

    return iconMap[item.type]?[item.status] ?? Container();
  }
}
