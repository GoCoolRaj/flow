import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/dashboard/dashboard_router.dart';
import 'package:video_player/video_player.dart';

class ProfileCompletedScreen extends StatefulWidget {
  const ProfileCompletedScreen({super.key});

  @override
  State<ProfileCompletedScreen> createState() => _ProfileCompletedScreenState();
}

class _ProfileCompletedScreenState extends State<ProfileCompletedScreen> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    _controller = VideoPlayerController.asset(Assets.videos.completeProfile)
      ..initialize().then((_) {
        _controller
          ..setLooping(true)
          ..play();
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    'Welcome to Quilt Flow!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: QuiltTheme.fontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your daily mindful moment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: QuiltTheme.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  QuiltButton(
                    textString: 'Continue to Feed',
                    expandButton: true,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    completedTextStyle: QuiltTheme.buttonText.copyWith(
                      fontSize: 16,
                    ),
                    onPressed: (_) {
                      context.go(DashboardRouter.homeFullPath);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
