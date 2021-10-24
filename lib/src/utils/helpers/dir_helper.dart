import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';

class DirHelper {
  static Future<String> downloadPath() async {
    if (Platform.isAndroid) {
      final path1 = join(
          'storage', "emulated", "0", "Documents", VChatAppService.to.appName);
      final dir = await Directory(path1).create(recursive: true);
      return "${dir.path}/";
    } else {
      final path = (await getApplicationDocumentsDirectory()).path;
      return "$path/";
    }
  }
}
