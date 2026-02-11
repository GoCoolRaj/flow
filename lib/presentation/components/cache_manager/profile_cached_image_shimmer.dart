import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/presentation/components/cache_manager/base_cached_image_shimmer.dart';
import 'package:quilt_flow_app/presentation/components/cache_manager/profile_cache_manager.dart';

class ProfileCachedImageShimmer extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final bool isLoading;
  final BoxFit? boxFit;
  final double? width;
  final double? height;
  final bool isShowLoader;
  final Alignment alignment;

  const ProfileCachedImageShimmer({
    super.key,
    required this.imageUrl,
    this.name,
    this.isLoading = false,
    this.isShowLoader = false,
    this.boxFit = BoxFit.contain,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildInitialsAvatar();
    }
    return BaseCachedImageShimmer(
      imageUrl: imageUrl,
      isLoading: isLoading,
      showLoader: isShowLoader,
      boxFit: boxFit,
      width: width,
      height: height,
      alignment: alignment,
      cacheManager: GetIt.I<ProfileCacheManager>().instance,
    );
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: width ?? 24,
      height: height ?? 24,
      decoration: const BoxDecoration(
        color: QuiltTheme.profileInitialBackgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _getInitials(name ?? ''),
        textAlign: TextAlign.center,
        style: QuiltTheme.simpleWhiteTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }

  // Future<bool> isImageAccessible(String url) async {
  //   try {
  //     final dio = GetIt.I<Dio>();
  //     final response = await dio.head(url,
  //         options: Options(
  //             followRedirects: false, validateStatus: (status) => true));
  //     return response.statusCode == 200;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "";
    final parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      return (parts[0].substring(0, 1) + parts[1].substring(0, 1))
          .toUpperCase();
    }
  }
}
