import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:shimmer/shimmer.dart';

class BaseCachedImageShimmer extends StatelessWidget {
  final String? imageUrl;
  final bool isLoading;
  final BoxFit? boxFit;
  final double? width;
  final double? height;
  final bool showLoader;
  final Alignment alignment;
  final BaseCacheManager cacheManager;

  const BaseCachedImageShimmer({
    required this.imageUrl,
    required this.cacheManager,
    this.isLoading = false,
    this.showLoader = false,
    this.boxFit = BoxFit.contain,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading || imageUrl == null || (imageUrl?.isEmpty ?? true)) {
      return SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            ShimmerPlaceholder(width: width, height: height),
            if (showLoader)
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(right: 0),
                  height: 70,
                  width: 70,
                  child: Lottie.asset(Assets.lottie.loader),
                ),
              ),
          ],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      placeholder: (context, url) =>
          ShimmerPlaceholder(width: width, height: height),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      cacheManager: cacheManager,
      fit: boxFit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;

  const ShimmerPlaceholder({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: QuiltTheme.shimmerBaseColor,
      highlightColor: QuiltTheme.shimmerHighlightColor,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: QuiltTheme.shimmerBaseColor,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.only(right: 30),
            height: 70,
            width: 70,
            child: Lottie.asset(Assets.lottie.loader),
          ),
        ),
      ),
    );
  }
}
