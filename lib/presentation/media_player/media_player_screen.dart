import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/components/custom_track_shape.dart';
import 'package:quilt_flow_app/presentation/media_player/bloc/media_player_bloc.dart';
import 'package:quilt_flow_app/presentation/media_player/bloc/media_player_event.dart';
import 'package:quilt_flow_app/presentation/media_player/bloc/media_player_state.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MediaPlayerScreen extends StatefulWidget {
  final ContentItem? content;
  final VideoPlayerController? videoPlayerController;

  const MediaPlayerScreen({
    super.key,
    this.content,
    this.videoPlayerController,
  });

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen>
    with WidgetsBindingObserver {
  MediaPlayerBloc? _mediaPlayerBloc;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mediaPlayerBloc = context.read<MediaPlayerBloc>();
      _mediaPlayerBloc?.add(
        InitializePlayer(
          content: widget.content,
          videoPlayerController: widget.videoPlayerController,
        ),
      );
    });
  }

  checkVideoRatio(double width, double height) {
    if (width > height) {
      return BoxFit.contain;
    } else if (width < height) {
      return BoxFit.cover;
    } else {
      return BoxFit.contain;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _mediaPlayerBloc?.add(PauseMedia());
    } else if (state == AppLifecycleState.resumed) {
      _mediaPlayerBloc?.add(PlayMedia());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<MediaPlayerBloc, MediaPlayerState>(
          builder: (context, state) {
            if (state.isLoading || state.videoController == null) {
              return Center(
                child: Lottie.asset(Assets.lottie.loader, height: 70),
              );
            }
            double sliderWidth = MediaQuery.of(context).size.width;
            const thumbWidth = 20;
            double offsetValue =
                (sliderWidth - thumbWidth) *
                (state.sliderValue! /
                    state.videoController!.value.duration.inSeconds.toDouble());

            return Stack(
              children: [
                if (state.videoController != null)
                  VisibilityDetector(
                    key: const Key("media_detector_key"),
                    child: SizedBox.expand(
                      child: FittedBox(
                        fit: checkVideoRatio(
                          state.videoController!.value.size.width,
                          state.videoController!.value.size.height,
                        ),
                        child: SizedBox(
                          width: state.videoController!.value.size.width,
                          height: state.videoController!.value.size.height,
                          child: VideoPlayer(state.videoController!),
                        ),
                      ),
                    ),
                    onVisibilityChanged: (info) {
                      if (info.visibleFraction == 1) {
                        _mediaPlayerBloc?.add(PlayMedia());
                      } else {
                        _mediaPlayerBloc?.add(PauseMedia());
                      }
                    },
                  ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          /* Expanded(
                            child: Column(
                          children: [
                            Text(
                              widget.content?.content.description ?? "",
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${widget.content?.content.contentDuration} min',
                              style: QuiltTheme.mediaScreenDurationText,
                            ),
                          ],
                        )),*/
                          IconButton(
                            icon: Icon(
                              state.isMuted
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                _mediaPlayerBloc?.add(ToggleMute()),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                height: 70,
                                alignment: Alignment.bottomCenter,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: !state.isSliding
                                                ? 0
                                                : 10,
                                          ),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                                overlayRadius: 20,
                                              ),
                                          trackHeight: 2,
                                          trackShape: CustomTrackShape(),
                                          thumbColor: Colors.white,
                                          activeTrackColor: Colors.white,
                                          inactiveTrackColor: Colors.white30,
                                          overlayColor: Colors.white.withAlpha(
                                            32,
                                          ),
                                        ),
                                        child: Slider(
                                          min: 0,
                                          max: state
                                              .videoController!
                                              .value
                                              .duration
                                              .inSeconds
                                              .toDouble(),
                                          value: state.sliderValue!,
                                          onChanged: (value) {
                                            final position = Duration(
                                              seconds: value.toInt(),
                                            );
                                            _mediaPlayerBloc?.add(
                                              SeekTo(
                                                position: position,
                                                seekbarValue: value,
                                                isSliding: true,
                                              ),
                                            );
                                          },
                                          onChangeEnd: (value) {
                                            _mediaPlayerBloc?.add(
                                              const Sliding(isSliding: false),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    if (state.isSliding)
                                      Positioned(
                                        left: offsetValue - 30,
                                        bottom: 30,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(30),
                                                ),
                                          ),
                                          child: Text(
                                            state.positionText!,
                                            style: QuiltTheme.snackBarChangeText
                                                .copyWith(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    icon: Assets.icons.mediaBackward.svg(
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      width: 24,
                                    ),
                                    onPressed: () => context
                                        .read<MediaPlayerBloc>()
                                        .add(BackwardMedia()),
                                  ),
                                  IconButton(
                                    icon: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(
                                          0xFFF8F7F8,
                                        ).withValues(alpha: 0.2),
                                      ),
                                      height: 60,
                                      width: 60,
                                      child: Icon(
                                        state.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (state.isPlaying) {
                                        context.read<MediaPlayerBloc>().add(
                                          PauseMedia(),
                                        );
                                      } else {
                                        context.read<MediaPlayerBloc>().add(
                                          PlayMedia(),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Assets.icons.mediaForward.svg(
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      width: 24,
                                    ),
                                    onPressed: () {
                                      context.read<MediaPlayerBloc>().add(
                                        ForwardMedia(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mediaPlayerBloc?.close();
    _mediaPlayerBloc = null;
    super.dispose();
  }
}
