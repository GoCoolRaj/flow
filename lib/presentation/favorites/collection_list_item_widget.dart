import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';

class CollectionListItem extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final bool? isFavorite;
  final bool? isShowBookmarkIcon;
  final VoidCallback? onTap;

  const CollectionListItem({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.isShowBookmarkIcon = true,
    this.isFavorite = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: QuiltTheme.settingInfoText.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: QuiltTheme.dialogMessageStyle),
                ],
              ),
            ),
            if (isShowBookmarkIcon!)
              !isFavorite!
                  ? SizedBox(
                      height: 40,
                      width: 40,
                      child: Icon(
                        Icons.bookmark_outline,
                        color: !isFavorite!
                            ? Colors.white
                            : QuiltTheme.tertiaryColor,
                        size: 24,
                      ),
                    )
                  : Stack(
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
          ],
        ),
      ),
    );
  }
}
