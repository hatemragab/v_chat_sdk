// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart' as u;
import 'package:v_platform/v_platform.dart';

class DeviceInfoHelper {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final uuId = const u.Uuid();

  Future<String> getId() async {
    if (VPlatforms.isIOS) {
      final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.identifierForVendor ??
          iosDeviceInfo.name + iosDeviceInfo.model; // unique ID on iOS
    } else if (VPlatforms.isAndroid) {
      final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    } else if (VPlatforms.isWeb) {
      final webInfo = await deviceInfoPlugin.webBrowserInfo;
      return webInfo.userAgent ?? uuId.v4();
    } else if (VPlatforms.isMacOs) {
      final macInfo = await deviceInfoPlugin.macOsInfo;
      return macInfo.model +
          macInfo.arch +
          macInfo.computerName +
          macInfo.hostName;
    } else if (VPlatforms.isWindows) {
      final windowsInfo = await deviceInfoPlugin.windowsInfo;
      return windowsInfo.deviceId;
    }
    return uuId.v4();
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
