import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';

class CollectionGrid extends StatelessWidget {
  final int experienceCount;
  const CollectionGrid({super.key, required this.experienceCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: QuiltTheme.otpDefaultBorderColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: _buildGridContent(),
        ),
      ),
    );
  }

  Widget _buildGridContent() {
    if (experienceCount == 0) {
      return Center(child: Assets.icons.emptyFavoriteIcon.svg());
    }
    switch (experienceCount) {
      case 1:
        return SizedBox(
          height: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Assets.images.favoriteOne.image(fit: BoxFit.cover),
          ),
        );
      case 2:
        return Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 2),
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Assets.images.favoriteOne.image(fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.only(left: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Assets.images.favoriteTwo.image(fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.only(left: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Assets.images.favoriteFour.image(fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.only(bottom: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Assets.images.favoriteThree.image(
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.only(top: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Assets.images.favoriteFour.image(
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.only(bottom: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Assets.images.favoriteFive.image(
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.only(top: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Assets.images.favoriteSix.image(
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.only(bottom: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Assets.images.favoriteSeven.image(
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      margin: const EdgeInsets.only(top: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Assets.images.favoriteEight.image(
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }
}
