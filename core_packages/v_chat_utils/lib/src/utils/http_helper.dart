// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:v_platform/v_platform.dart';

abstract class HttpHelpers {
  static Future<http.MultipartFile> getMultipartFile({
    required VPlatformFile source,
    String fieldName = "file",
  }) async {
    if (VPlatforms.isWeb) {
      return http.MultipartFile.fromBytes(
        fieldName,
        filename: source.name,
        source.bytes!,
        contentType: source.mimeType == null
            ? null
            : MediaType.parse(
                source.mimeType!,
              ),
      );
    }
    return http.MultipartFile.fromPath(
      fieldName,
      source.fileLocalPath!,
      filename: source.name,
      contentType: source.mimeType == null
          ? null
          : MediaType.parse(
              source.mimeType!,
            ),
    );
  }
}
