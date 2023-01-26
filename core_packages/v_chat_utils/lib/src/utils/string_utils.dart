import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../v_chat_utils.dart';

abstract class VStringUtils {
  static final RegExp vMentionRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
  static Future<bool> lunchLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> lunchMap({
    required double latitude,
    required double longitude,
    required String title,
    String? description,
  }) async {
    return await MapLauncher.showMarker(
      mapType: VPlatforms.isIOS ? MapType.apple : MapType.google,
      coords: Coords(
        latitude,
        longitude,
      ),
      title: title,
      description: description,
    );
  }
}
