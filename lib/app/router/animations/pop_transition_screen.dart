import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class PopTransitionScreen<T> extends CustomTransitionPage<T> {
  PopTransitionScreen({
    required super.child,
    super.transitionDuration = const Duration(milliseconds: 200),
    super.reverseTransitionDuration = const Duration(milliseconds: 200),
  }) : super(
          transitionsBuilder: (
            _,
            animation,
            __,
            child,
          ) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
        );
}
