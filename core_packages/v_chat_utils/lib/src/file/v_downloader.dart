import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../v_chat_utils.dart';

abstract class VFileUtils {
  static Future<String> _downloadPath(String appName) async {
    if (Platform.isAndroid) {
      final path1 = join(
        'storage',
        "emulated",
        "0",
        "Documents",
        appName,
      );
      final dir = await Directory(path1).create(recursive: true);
      return "${dir.path}/";
    } else if (Platform.isIOS) {
      final path = (await getApplicationDocumentsDirectory()).path;
      return "$path/";
    } else {
      throw 'Unsupported Platform';
    }
  }

  static Future<String> downloadFileForWeb(
    VPlatformFileSource fileAttachment,
  ) async {
    final bytes = (await http.get(Uri.parse(fileAttachment.url!))).bodyBytes;
    return await FileSaver.instance.saveFile(
      fileAttachment.name,
      bytes,
      fileAttachment.mimeType!,
    );
  }

  ///make sure you ask for storage permissions
  static Future<String> safeToPublicPath({
    required VPlatformFileSource fileAttachment,
    required String appName,
  }) async {
    if (VPlatforms.isMobile) {
      final newFilePath = (await _downloadPath(appName)) + fileAttachment.name;
      final file = File(newFilePath);
      if (file.existsSync()) {
        return newFilePath;
      }
      final res = await vSafeApiCall<Uint8List>(
        request: () async {
          return (await http.get(Uri.parse(fileAttachment.url!))).bodyBytes;
        },
        onSuccess: (response) async {
          // write to file
          await file.writeAsBytes(response);
        },
        onError: (exception, trace) {
          throw Future.error(exception, trace);
        },
      );
      if (res == null) throw ("Error while download file");
      return newFilePath;
    }
    return downloadFileForWeb(fileAttachment);
  }
}
