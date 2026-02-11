import 'package:flutter/material.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/components/quilt_overlay_indicator.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_bloc.dart';
import 'package:quilt_flow_app/presentation/home/feed_media_page.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';
import 'package:quilt_flow_app/presentation/home/home_page_full_content.dart';
import 'package:video_player/video_player.dart';

class FeedPage<T extends FeedBloc> extends StatelessWidget {
  final T feedBloc;
  final FeedScope feedScope;
  final ContentItem contentItem;
  final VideoPlayerController? videoPlayerController;
  final bool isMuted;
  final bool? showLoading;
  final String? thumbnailPath;
  final String? userId;
  final bool isPaused;
  final GestureTapDownCallback onDoubleTapDown;
  final VoidCallback? onFeedPressed;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onFeedbackPressed;
  final bool showFeedback;

  const FeedPage({
    super.key,
    required this.feedBloc,
    required this.feedScope,
    required this.contentItem,
    this.videoPlayerController,
    this.isMuted = false,
    this.showLoading = false,
    this.thumbnailPath = "",
    this.userId = "",
    this.isPaused = false,
    required this.onDoubleTapDown,
    this.onFeedPressed,
    this.onCommentPressed,
    this.onFeedbackPressed,
    this.showFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onFeedPressed,
          onDoubleTapDown: onDoubleTapDown,
          child: videoPlayerController != null
              ? FeedMediaPage(controller: videoPlayerController!)
              : const QuiltOverlayIndicator(),
        ),
        IgnorePointer(
          ignoring: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: QuiltTheme.feedOverlayGradient,
            ),
          ),
        ),
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: HomePageFullContent<T>(
            feedBloc: feedBloc,
            feedScope: feedScope,
            contentItem: contentItem,
            isMuted: isMuted,
            isPaused: isPaused,
            userId: userId,
            onCommentPressed: onCommentPressed,
            onFeedbackPressed: onFeedbackPressed,
            showFeedback: showFeedback,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            opacity: isPaused ? 1 : 0,
            duration: isPaused
                ? const Duration(milliseconds: 0)
                : const Duration(milliseconds: 500),
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              child: isPaused
                  ? Assets.icons.play.svg()
                  : Assets.icons.pause.svg(),
            ),
          ),
        ),
        // if (isPaused &&
        //     contentItem.content.associatedFabrics.isNotEmpty &&
        //     contentItem.content.associatedFabrics.first.isEligible)
        //   Align(
        //     alignment: Alignment.topCenter,
        //     child: GestureDetector(
        //       child: Container(
        //         margin: const EdgeInsets.only(top: 150),
        //         child: FabricDiscoveryWidget(
        //             fabricName:
        //                 "@${contentItem.content.associatedFabrics.first.name}",
        //             fabricThumbnail: contentItem.content.associatedFabrics.first
        //                 .transparentBackgroundThumbnail),
        //       ),
        //       onTap: () {
        //         final eligibleFabrics = contentItem.content.associatedFabrics;
        //         final associatedFabric = eligibleFabrics.first;

        //         final fabricData =
        //             FabricData.fromAssociatedFabricsDetails(associatedFabric);
        //         context.pushNamed(
        //           MainRouter.fabricDetailsRoute,
        //           extra: {
        //             'fabric': fabricData,
        //             MainRouter.fabricCreatedUserIdParamKey:
        //                 associatedFabric.createdUserId,
        //           },
        //         );
        //       },
        //     ),
        //   )
      ],
    );
  }
}
