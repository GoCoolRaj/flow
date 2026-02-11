import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';

class QuiltOverlayIndicator extends StatelessWidget {
  const QuiltOverlayIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Lottie.asset(Assets.lottie.loader, height: 120, width: 120),
      ),
    );
  }
}
