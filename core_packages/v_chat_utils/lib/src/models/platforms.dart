// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:universal_html/html.dart';

import '../../v_chat_utils.dart';

abstract class VPlatforms {
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

  static bool get isWebRunOnMobile {
    final userAgent = window.navigator.userAgent.toString().toLowerCase();
    if (userAgent.contains("iphone")) return true;
    if (userAgent.contains("ipad")) return true;
    if (userAgent.contains("android")) return true;
    return false;
  }

  static Future<http.MultipartFile> getMultipartFile({
    required VPlatformFileSource source,
    String fieldName = "file",
  }) async {
    if (VPlatforms.isWeb) {
      return http.MultipartFile.fromBytes(
        fieldName,
        filename: source.name,
        source.bytes!,
        contentType: source.mimeType == null
            ? null
            : MediaType.parse(
                source.mimeType!,
              ),
      );
    }
    return http.MultipartFile.fromPath(
      fieldName,
      source.filePath!,
      filename: source.name,
      contentType: source.mimeType == null
          ? null
          : MediaType.parse(
              source.mimeType!,
            ),
    );
  }
}
