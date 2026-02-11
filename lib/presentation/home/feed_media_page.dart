import 'package:flutter/material.dart';
import 'package:quilt_flow_app/presentation/components/quilt_overlay_indicator.dart';
import 'package:video_player/video_player.dart';

class FeedMediaPage extends StatelessWidget {
  final VideoPlayerController controller;

  const FeedMediaPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const QuiltOverlayIndicator();
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
