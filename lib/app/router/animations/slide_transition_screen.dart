import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class SlideTransitionScreen<T> extends CustomTransitionPage<T> {
  SlideTransitionScreen({
    required super.child,
    super.transitionDuration = const Duration(milliseconds: 150),
    super.reverseTransitionDuration = const Duration(milliseconds: 150),
  }) : super(
          transitionsBuilder: (
            _,
            animation,
            __,
            child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
