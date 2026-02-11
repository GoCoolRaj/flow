import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/app/bloc/base/quilt_base_bloc.dart';
import 'package:quilt_flow_app/app/helpers/date_time_utils.dart';
import 'package:quilt_flow_app/app/router/router_manager.dart';
import 'package:quilt_flow_app/presentation/media_player/bloc/media_player_event.dart';
import 'package:quilt_flow_app/presentation/media_player/bloc/media_player_state.dart';
import 'package:video_player/video_player.dart';

class MediaPlayerBloc extends BaseBloc<MediaPlayerEvent, MediaPlayerState> {
  final int forwardSeconds = 3;
  final double mute = 0.0;
  final double unMute = 1.0;
  final _routerManager = GetIt.I.get<RouterManager>();

  MediaPlayerBloc() : super(const MediaPlayerState()) {
    on<InitializePlayer>(_onInitializePlayer);
    on<PlayMedia>(_onPlayMedia);
    on<PauseMedia>(_onPauseMedia);
    on<SeekTo>(_onSeekTo);
    on<ForwardMedia>(_onForwardMedia);
    on<BackwardMedia>(_onBackwardMedia);
    on<UpdatePosition>(_onUpdatePosition);
    on<ToggleMute>(_onToggleMute);
    on<Sliding>(_onSliding);
  }

  Future<void> _onInitializePlayer(
    InitializePlayer event,
    Emitter<MediaPlayerState> emit,
  ) async {
    try {
      bool? isPlaying = event.videoPlayerController?.value.isPlaying;
      emit(
        state.copyWith(
          isLoading: event.videoPlayerController == null,
          isDisposable: event.videoPlayerController == null,
          videoController: event.videoPlayerController,
          isPlaying: isPlaying,
          contentItem: event.content,
        ),
      );
      var videoUrl = state.contentItem?.content.contentUrl;

      if (videoUrl == null) return;
      if (event.videoPlayerController == null) {
        final List<Future> initializationFutures = [];
        VideoPlayerController? videoController;

        videoController = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        initializationFutures.add(videoController.initialize());

        await Future.wait(initializationFutures);

        emit(
          state.copyWith(
            isLoading: false,
            videoController: videoController,

            isPlaying: true,
          ),
        );
      }
      if (state.videoController != null) {
        Future.delayed(const Duration(seconds: 1), () {
          state.videoController?.play();
        });
      }

      final duration =
          state.videoController?.value.duration ?? const Duration(minutes: 5);
      emit(state.copyWith(duration: duration));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _updatePosition() {
    add(UpdatePosition(state.videoController!.value.position));
  }

  Future<void> _onPlayMedia(
    PlayMedia event,
    Emitter<MediaPlayerState> emit,
  ) async {
    if (_routerManager.currentRoute != "/media") return;
    await state.videoController?.play();

    emit(state.copyWith(isPlaying: true));
  }

  Future<void> _onPauseMedia(
    PauseMedia event,
    Emitter<MediaPlayerState> emit,
  ) async {
    await state.videoController?.pause();

    emit(state.copyWith(isPlaying: false));
  }

  Future<void> _onSeekTo(SeekTo event, Emitter<MediaPlayerState> emit) async {
    emit(
      state.copyWith(
        position: event.position,
        isSliding: event.isSliding,
        sliderValue: event.seekbarValue!,
        positionText: DateTimeUtils.mediaPlayerFormat(event.position!),
      ),
    );
  }

  void _onUpdatePosition(UpdatePosition event, Emitter<MediaPlayerState> emit) {
    emit(
      state.copyWith(
        position: event.position,
        sliderValue: event.position.inSeconds.toDouble(),
        positionText: DateTimeUtils.mediaPlayerFormat(event.position),
      ),
    );
  }

  Future<void> _onToggleMute(
    ToggleMute event,
    Emitter<MediaPlayerState> emit,
  ) async {
    await state.videoController?.setVolume(state.isMuted ? unMute : mute);

    emit(state.copyWith(isMuted: !state.isMuted));
  }

  Future<void> _onSliding(Sliding event, Emitter<MediaPlayerState> emit) async {
    emit(state.copyWith(isSliding: event.isSliding));
  }

  Future<void> _onForwardMedia(
    ForwardMedia event,
    Emitter<MediaPlayerState> emit,
  ) async {
    final newPosition = state.position + Duration(seconds: forwardSeconds);
    add(
      SeekTo(
        position: newPosition,
        isSliding: false,
        seekbarValue: state.sliderValue,
      ),
    );
  }

  Future<void> _onBackwardMedia(
    BackwardMedia event,
    Emitter<MediaPlayerState> emit,
  ) async {
    final newPosition = state.position - Duration(seconds: forwardSeconds);
    add(
      SeekTo(
        position: newPosition.isNegative ? Duration.zero : newPosition,
        isSliding: false,
        seekbarValue: state.sliderValue,
      ),
    );
  }

  @override
  Future<void> close() {
    state.videoController?.removeListener(_updatePosition);
    if (state.isDisposable) {
      state.videoController?.dispose();
    }

    return super.close();
  }
}
