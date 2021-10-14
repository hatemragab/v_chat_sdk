import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../api_utils/server_config.dart';
import '../vchat_constants.dart';

class DirHelper {
  static Future<String> downloadPath() async {
    if (Platform.isAndroid) {
      final path1 = join('storage', "emulated", "0", "Download", vchatAppName);
      final dir = await Directory(path1).create(recursive: true);
      return "${dir.path}/";
    } else {
      final path = (await getApplicationDocumentsDirectory()).path;
      return "$path/";
    }
  }
}
