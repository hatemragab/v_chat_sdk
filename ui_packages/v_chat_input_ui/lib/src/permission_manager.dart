import 'package:permission_handler/permission_handler.dart';

abstract class PermissionManager {
  static Future<bool> isAllowRecord() async {
    return Permission.microphone.isGranted;
  }

  static Future<bool> isCameraAllowed() async {
    return Permission.camera.isGranted;
  }

  static Future<bool> askForCamera() async {
    final st = await Permission.camera.request();
    return st == PermissionStatus.granted;
  }

  static Future<bool> askForRecord() async {
    final st = await Permission.microphone.request();
    return st == PermissionStatus.granted;
  }
}
