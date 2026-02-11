import 'package:flutter/material.dart';

class PositionedAnimation extends StatelessWidget {
  final AnimationController controller;
  final Widget animatedWidget;
  final double startPosition;
  final double endPosition;
  final double widgetWidth; // Add width of the widget to dynamically center it

  const PositionedAnimation({
    super.key,
    required this.controller,
    required this.animatedWidget,
    required this.startPosition,
    required this.endPosition,
    required this.widgetWidth, // Pass widget width
  });

  @override
  Widget build(BuildContext context) {
    // Create the animation using the provided controller
    final animation =
        Tween<double>(begin: startPosition, end: endPosition).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut, // Customize the curve as needed
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: animation
              .value, // Update the top position with the animated value
          left: MediaQuery.of(context).size.width / 2 -
              widgetWidth / 2, // Center dynamically
          child: animatedWidget, // Use the passed widget for animation
        );
      },
    );
  }
}
