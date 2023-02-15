// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:permission_handler/permission_handler.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class PermissionManager {
  static Future<bool> isAllowRecord() async {
    if (VPlatforms.isWeb) return true;
    return Permission.microphone.isGranted;
  }

  static Future<bool> isCameraAllowed() async {
    if (VPlatforms.isWeb) return true;
    return Permission.camera.isGranted;
  }

  static Future<bool> askForCamera() async {
    if (VPlatforms.isWeb) return true;
    final st = await Permission.camera.request();
    return st == PermissionStatus.granted;
  }

  static Future<bool> askForRecord() async {
    if (VPlatforms.isWeb) return true;
    final st = await Permission.microphone.request();
    return st == PermissionStatus.granted;
  }
}
