import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:video_player/video_player.dart';

class MediaPlayerState extends Equatable {
  final bool isLoading;
  final bool isPlaying;
  final bool isSliding;
  final Duration position;
  final Duration duration;
  final bool isDisposable;
  final ContentItem? contentItem;
  final bool isMuted;
  final double? sliderValue;
  final String? positionText;
  final VideoPlayerController? videoController;

  const MediaPlayerState({
    this.isLoading = true,
    this.isPlaying = false,
    this.isSliding = false,
    this.isDisposable = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isMuted = false,
    this.contentItem,
    this.sliderValue = 0,
    this.positionText = "00:00",
    this.videoController,
  });

  MediaPlayerState copyWith({
    bool? isLoading,
    bool? isPlaying,
    bool? isDisposable,
    bool? isSliding,
    Duration? position,
    Duration? duration,
    ContentItem? contentItem,
    double? sliderValue,
    bool? isMuted,
    String? positionText,
    VideoPlayerController? videoController,
  }) {
    return MediaPlayerState(
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isMuted: isMuted ?? this.isMuted,
      isDisposable: isDisposable ?? this.isDisposable,
      isSliding: isSliding ?? this.isSliding,
      positionText: positionText ?? this.positionText,
      sliderValue: sliderValue ?? this.sliderValue,
      videoController: videoController ?? this.videoController,

      contentItem: contentItem ?? this.contentItem,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isPlaying,
    position,
    duration,
    isMuted,
    isDisposable,
    positionText,
    sliderValue,
    videoController,

    isSliding,
    contentItem,
  ];
}
