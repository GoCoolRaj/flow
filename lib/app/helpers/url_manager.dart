import 'package:url_launcher/url_launcher.dart';

class UrlManager {
  Future<void> launch(String url) async {
    await launchUrl(Uri.parse(url));
  }

  Future<bool> canLaunch(String url) async {
    return await canLaunchUrl(Uri.parse(url));
  }
}
