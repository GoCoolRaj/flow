import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quilt_flow_app/domain/home/model/content_flavours.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:video_player/video_player.dart';

class HomeMedia {
  final ContentFormat contentFormat;
  final ContentItem contentItem;
  VideoPlayerController? videoPlayerController;

  String? thumbnailPath;

  HomeMedia({
    required this.contentFormat,
    required this.contentItem,
    this.videoPlayerController,
    this.thumbnailPath,
  });

  HomeMedia copyWith({
    ContentFormat? contentFormat,
    VideoPlayerController? videoPlayerController,

    LottieComposition? initialLottie,
    String? thumbnailPath,
    ImageProvider? initialImageProvider,
  }) {
    return HomeMedia(
      contentFormat: contentFormat ?? this.contentFormat,
      contentItem: contentItem,
      videoPlayerController:
          videoPlayerController ?? this.videoPlayerController,
      thumbnailPath: thumbnailPath,
    );
  }
}
