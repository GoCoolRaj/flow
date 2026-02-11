import 'package:flutter/material.dart';
import 'package:quilt_flow_app/presentation/components/cache_manager/profile_cached_image_shimmer.dart';

class HomeProfileIcon extends StatefulWidget {
  final String imageUrl;
  const HomeProfileIcon({super.key, required this.imageUrl});

  @override
  State<HomeProfileIcon> createState() => _HomeProfileIconState();
}

class _HomeProfileIconState extends State<HomeProfileIcon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: ProfileCachedImageShimmer(
        imageUrl: widget.imageUrl,
        boxFit: BoxFit.cover,
        width: 24,
        height: 24,
        name: "",
      ),
    );
  }
}
