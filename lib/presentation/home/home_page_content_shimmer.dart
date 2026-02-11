import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:shimmer/shimmer.dart';

class HomePageContentShimmer extends StatelessWidget {
  const HomePageContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: QuiltTheme.dialogBackgroundColor,
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: QuiltTheme.shimmerBaseLight,
        highlightColor: QuiltTheme.shimmerHighlightLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              height: 30,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: QuiltTheme.shimmerSurfaceColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Container(
              width: 150,
              height: 16,
              color: QuiltTheme.shimmerSurfaceColor,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 36,
                  decoration: BoxDecoration(
                    color: QuiltTheme.shimmerSurfaceColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 16,
                  decoration: BoxDecoration(
                    color: QuiltTheme.shimmerSurfaceColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
