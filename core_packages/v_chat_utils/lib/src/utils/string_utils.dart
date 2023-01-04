import 'package:url_launcher/url_launcher.dart';

abstract class VStringUtils {
  static Future<bool> lunchLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    } else {
      return false;
    }
  }
}
