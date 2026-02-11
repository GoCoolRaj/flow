import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomSlideTransitionPage<T> extends CustomTransitionPage<T> {
  BottomSlideTransitionPage({
    required super.child,
    super.transitionDuration = const Duration(milliseconds: 250),
    super.reverseTransitionDuration = const Duration(milliseconds: 250),
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            return SlideTransition(
              position: slide,
              child: child,
            );
          },
        );
}
