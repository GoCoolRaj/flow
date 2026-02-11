import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class VerticalSlideTransitionScreen<T> extends CustomTransitionPage<T> {
  final bool isGoingDown;

  VerticalSlideTransitionScreen({
    required super.child,
    this.isGoingDown = true,
  }) : super(
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            final beginOffset =
                isGoingDown ? const Offset(0, 1) : const Offset(0, -1);
            const endOffset = Offset.zero;

            return SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: endOffset,
              ).animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        );
}
