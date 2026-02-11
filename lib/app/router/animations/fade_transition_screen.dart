import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class FadeTransitionScreen<T> extends CustomTransitionPage<T> {
  FadeTransitionScreen({
    required super.child,
    super.transitionDuration = const Duration(milliseconds: 150),
  }) : super(
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
