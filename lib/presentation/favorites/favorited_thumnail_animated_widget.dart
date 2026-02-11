import 'dart:io';

import 'package:flutter/material.dart';

class FavoriteThumbnailAnimatedWidget extends StatefulWidget {
  final String thumbnailPath;
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback? onAnimationComplete;
  final Duration duration;
  final double thumbnailSize;

  const FavoriteThumbnailAnimatedWidget({
    super.key,
    required this.thumbnailPath,
    required this.startPosition,
    required this.endPosition,
    this.onAnimationComplete,
    this.duration = const Duration(milliseconds: 500),
    this.thumbnailSize = 40.0,
  });

  @override
  State<FavoriteThumbnailAnimatedWidget> createState() =>
      _FavoriteAnimationWidgetState();
}

class FavoriteAnimationManager {
  OverlayEntry? _overlayEntry;

  void startFavoriteAnimation(
    BuildContext context, {
    required String thumbnailPath,
    required Offset startPosition,
  }) {
    clearOverlay();

    if (thumbnailPath.isEmpty) return;
    final size = MediaQuery.of(context).size;
    final endPosition = Offset(
      size.width - 56,
      size.height - 28,
    );
    _overlayEntry = OverlayEntry(
      builder: (context) => FavoriteThumbnailAnimatedWidget(
        startPosition: startPosition,
        endPosition: endPosition,
        thumbnailPath: thumbnailPath,
        onAnimationComplete: clearOverlay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void clearOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _FavoriteAnimationWidgetState
    extends State<FavoriteThumbnailAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _yAnimation = Tween<double>(
      begin: widget.startPosition.dy,
      end: widget.endPosition.dy,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0),
        weight: 70.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 80.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 20.0,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.startPosition.dx,
          top: _yAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: SizedBox(
                width: widget.thumbnailSize,
                height: widget.thumbnailSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(widget.thumbnailPath),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
