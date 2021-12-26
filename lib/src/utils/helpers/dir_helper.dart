import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v_chat_sdk/src/utils/api_utils/dio/v_chat_sdk_exception.dart';

import '../../services/v_chat_app_service.dart';

class DirHelper {
  DirHelper._();

  static Future<String> downloadPath() async {
    if (Platform.isAndroid) {
      final path1 = join(
        'storage',
        "emulated",
        "0",
        "Documents",
        VChatAppService.instance.appName,
      );
      final dir = await Directory(path1).create(recursive: true);
      return "${dir.path}/";
    } else if (Platform.isIOS) {
      final path = (await getApplicationDocumentsDirectory()).path;
      return "$path/";
    } else {
      throw VChatSdkException('Unsupported Platform');
    }
  }
}
