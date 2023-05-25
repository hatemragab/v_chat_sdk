// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:device_info_plus/device_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:uuid/uuid.dart' as u;
import 'package:v_platform/v_platform.dart';

class DeviceInfoHelper {
  final deviceInfoPlugin = DeviceInfoPlugin();

  Future<String> getId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId ??= const u.Uuid().v4();
  }

  Future<Map<String, dynamic>> getDeviceMapInfo() async {
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final data = deviceInfo.data;
    final newMap = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is Enum) {
        newMap[key] = value.name;
      } else {
        newMap[key] = value.toString();
      }
    });
    return newMap;
  }

  Future<bool> isRealDevice() async {
    if (VPlatforms.isMobile) {
      if (VPlatforms.isIOS) {
        final deviceInfo = await deviceInfoPlugin.iosInfo;
        return deviceInfo.isPhysicalDevice;
      } else {
        if (VPlatforms.isAndroid) {
          final deviceInfo = await deviceInfoPlugin.androidInfo;
          return deviceInfo.isPhysicalDevice;
        }
      }
    }
    return true;
  }
}
