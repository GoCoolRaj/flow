import 'package:equatable/equatable.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:video_player/video_player.dart';

sealed class MediaPlayerEvent extends Equatable {
  const MediaPlayerEvent();
  @override
  List<Object> get props => [];
}

class InitializePlayer extends MediaPlayerEvent {
  final ContentItem? content;
  final VideoPlayerController? videoPlayerController;

  const InitializePlayer({this.content, this.videoPlayerController});
}

class SeekTo extends MediaPlayerEvent {
  final Duration? position;
  final double? seekbarValue;
  final bool? isSliding;
  const SeekTo({this.position, this.seekbarValue, this.isSliding});
}

class ForwardMedia extends MediaPlayerEvent {}

class BackwardMedia extends MediaPlayerEvent {}

class UpdatePosition extends MediaPlayerEvent {
  final Duration position;
  const UpdatePosition(this.position);
}

class ToggleMute extends MediaPlayerEvent {}

class Sliding extends MediaPlayerEvent {
  final bool? isSliding;
  const Sliding({this.isSliding});
}

class PlayMedia extends MediaPlayerEvent {}

class PauseMedia extends MediaPlayerEvent {}
