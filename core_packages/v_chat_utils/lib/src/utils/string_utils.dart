// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../v_chat_utils.dart';

abstract class VStringUtils {
  static final RegExp vMentionRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");

  static String parseVMentions(String txt, {bool withOutAt = true}) {
    final readyToCopy = StringBuffer();
    final words = txt.split(" ");
    for (final element in words) {
      final match = VStringUtils.vMentionRegExp.firstMatch(element);
      if (match != null) {
        final matchTxt = match.group(1)!;
        if (withOutAt) {
          readyToCopy.write("${matchTxt.replaceFirst("@", "")} ");
        } else {
          readyToCopy.write("$matchTxt ");
        }
      } else {
        readyToCopy.write("$element ");
      }
    }
    return readyToCopy.toString();
  }

  static Future<bool> lunchLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    } else {
      return false;
    }
  }

  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
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
