import 'dart:io' as io;

import 'package:flutter/foundation.dart';

abstract class Platforms {
  static bool isWeb = kIsWeb;

  static bool get isMobile =>
      isWeb ? false : io.Platform.isAndroid || io.Platform.isIOS;

  static bool get isAndroid => isWeb ? false : io.Platform.isAndroid;

  static bool get isIOS => isWeb ? false : io.Platform.isIOS;

  static bool get isMac => isWeb ? false : io.Platform.isMacOS;

  static String get currentPlatform {
    if (isWeb) {
      return "Web";
    }
    if (isAndroid) {
      return "Android";
    }
    if (isIOS) {
      return "Ios";
    }
    if (isLinux) {
      return "Linux";
    }
    if (isWindows) {
      return "Windows";
    }
    if (isMac) {
      return "Mac";
    }
    return "";
  }

  static bool get isWindows => isWeb ? false : io.Platform.isWindows;

  static bool get isDeskTop => isWindows || isLinux || isMac;

  static bool get isLinux => isWeb ? false : io.Platform.isLinux;
}
