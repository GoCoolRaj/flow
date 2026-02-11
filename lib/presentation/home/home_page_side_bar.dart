import 'package:flutter/material.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/presentation/feed/bloc/feed_bloc.dart';
import 'package:quilt_flow_app/presentation/home/feed_scope.dart';
import 'package:quilt_flow_app/presentation/home/home_page_side_bar_social_actions.dart';

class HomePageSideBar<T extends FeedBloc> extends StatelessWidget {
  final T feedBloc;
  final Content content;
  final bool isMuted;
  final bool isPaused;
  final String? userId;
  final String? createdUserId;
  final FeedScope feedScope;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onFeedbackPressed;
  final bool showFeedback;

  const HomePageSideBar({
    super.key,
    required this.feedBloc,
    required this.content,
    required this.isMuted,
    required this.isPaused,
    required this.userId,
    required this.createdUserId,
    required this.feedScope,
    this.onCommentPressed,
    this.onFeedbackPressed,
    this.showFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        HomePageSideBarSocialActions<T>(
          feedBloc: feedBloc,
          content: content,
          isMuted: isMuted,
          isPaused: isPaused,
          userId: userId,
          createdUserId: createdUserId,
          feedScope: feedScope,
          onCommentPressed: onCommentPressed,
          onFeedbackPressed: onFeedbackPressed,
          showFeedback: showFeedback,
        ),
      ],
    );
  }
}
