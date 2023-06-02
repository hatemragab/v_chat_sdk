// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:v_platform/v_platform.dart';

abstract class VFileUtils {
  static Future<String> _downloadPath(String appName) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    return "$path/";
  }

  static Future<String> _downloadFileForWeb(
    VPlatformFile fileSource,
  ) async {
    final response = await http.get(Uri.parse(fileSource.url!));
    final bytes = response.bodyBytes;
    return await FileSaver.instance.saveFile(
      name: fileSource.name,
      bytes: bytes,
    );
  }

  /// make sure you ask for storage permissions
  static Future<String> saveFileToPublicPath({
    required VPlatformFile fileAttachment,
    required String appName,
  }) async {
    if (!VPlatforms.isMobile) {
      return _downloadFileForWeb(fileAttachment);
    }

    final newFilePath = "${await _downloadPath(appName)}${fileAttachment.name}";

    final file = File(newFilePath);
    if (file.existsSync()) {
      return file.path;
    }

    try {
      final response = await http.get(Uri.parse(fileAttachment.url!));
      await file.writeAsBytes(response.bodyBytes);
      return newFilePath;
    } catch (e, stackTrace) {
      throw Future.error(e, stackTrace);
    }
  }
}
