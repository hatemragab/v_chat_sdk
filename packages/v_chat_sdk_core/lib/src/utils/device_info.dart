import 'package:device_info_plus/device_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:uuid/uuid.dart' as u;

import '../types/platforms.dart';

class DeviceInfoHelper {
  final deviceInfoPlugin = DeviceInfoPlugin();

  Future<String> getId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId ??= const u.Uuid().v4();
  }

  Future<Map<String, dynamic>> getDeviceMapInfo() async {
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    return deviceInfo.data;
  }

  Future<bool> isRealDevice() async {
    if (Platforms.isMobile) {
      if (Platforms.isIOS) {
        final deviceInfo = await deviceInfoPlugin.iosInfo;
        return deviceInfo.isPhysicalDevice;
      } else {
        if (Platforms.isAndroid) {
          final deviceInfo = await deviceInfoPlugin.androidInfo;
          return deviceInfo.isPhysicalDevice;
        }
      }
    }
    return true;
  }
}
