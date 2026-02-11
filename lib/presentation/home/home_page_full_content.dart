import 'package:flutter/material.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_bloc.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';
import 'package:quilt_flow_app/presentation/home/home_page_feed_content.dart';
import 'package:quilt_flow_app/presentation/home/home_page_side_bar.dart';

class HomePageFullContent<T extends FeedBloc> extends StatelessWidget {
  final T feedBloc;
  final FeedScope feedScope;
  final ContentItem contentItem;
  final bool isMuted;
  final bool isPaused;
  final String? userId;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onFeedbackPressed;
  final bool showFeedback;

  const HomePageFullContent({
    super.key,
    required this.feedBloc,
    required this.feedScope,
    required this.contentItem,
    required this.isMuted,
    required this.isPaused,
    required this.userId,
    this.onCommentPressed,
    this.onFeedbackPressed,
    this.showFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    Content content = contentItem.content;
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: HomePageFeedContent<T>(
              contentItem: contentItem,
              feedScope: feedScope,
              feedBloc: feedBloc,
            ),
          ),
          HomePageSideBar<T>(
            feedBloc: feedBloc,
            content: content,
            isMuted: isMuted,
            isPaused: isPaused,
            userId: userId,
            createdUserId: contentItem.userId,
            feedScope: feedScope,
            onCommentPressed: onCommentPressed,
            onFeedbackPressed: onFeedbackPressed,
            showFeedback: showFeedback,
          ),
        ],
      ),
    );
  }
}
