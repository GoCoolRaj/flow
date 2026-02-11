import 'package:flutter/material.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/components/custom_webview.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';

class SessionCompletedScreen extends StatefulWidget {
  const SessionCompletedScreen({super.key});

  @override
  State<SessionCompletedScreen> createState() => _SessionCompletedScreenState();
}

class _SessionCompletedScreenState extends State<SessionCompletedScreen> {
  static const String _clinicUrl = 'https://cerebral.com/';

  void _openClinicWebView() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => const CustomWebView(url: _clinicUrl, title: 'Cerebral'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Session Complete',
          style: QuiltTheme.simpleWhiteTextStyle.copyWith(fontSize: 17),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(44.0),
        child: Column(
          children: [
            Text(
              "Daily Dose Complete!",
              style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                fontSize: 24,
                color: QuiltTheme.sessionCompletedTitleColor,
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Assets.images.doseCompleted.image(),
            ),
            const SizedBox(height: 24),
            Text(
              "If you need help, contact your doctor:",
              style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                fontSize: 16,
                color: QuiltTheme.sessionCompletedSubtitleColor,
              ),
            ),
            const SizedBox(height: 24),
            QuiltButton(
              textString: "Cerebral",
              buttonState: ButtonState.completed,
              leadingIcon: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Assets.images.cerebral.image(height: 27, width: 27),
              ),
              actionIcon: Assets.icons.rightArrowPointy.svg(
                height: 16,
                width: 16,
              ),
              onPressed: (_) => _openClinicWebView(),
            ),
          ],
        ),
      ),
    );
  }
}
