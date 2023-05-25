// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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

  static Future<VMessageImageData?> getVideoThumb({
    required VPlatformFile fileSource,
    int maxWidth = 600,
    int quality = 50,
  }) async {
    if (fileSource.isFromBytes || fileSource.isFromUrl) {
      return null;
    }

    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: fileSource.fileLocalPath!,
      maxWidth: maxWidth,
      quality: quality,
    );

    if (thumbPath == null) {
      return null;
    }

    final thumbImageData = await getImageInfo(
      fileSource: VPlatformFile.fromPath(
        fileLocalPath: thumbPath,
      ),
    );

    return VMessageImageData(
      fileSource: VPlatformFile.fromPath(fileLocalPath: thumbPath),
      width: thumbImageData.image.width,
      height: thumbImageData.image.height,
    );
  }

  static Future<int?> getVideoDurationMill(VPlatformFile file) async {
    if (file.isFromPath) {
      final controller = VideoPlayerController.file(
        File(file.fileLocalPath!),
      );
      await controller.initialize();
      final value = controller.value.duration.inMilliseconds;
      controller.dispose();
      return value;
    }
    return null;
  }

  //This is a function called "compressImage" that takes in a VPlatformFile object representing an image file and compresses it
  // if it is larger than a certain size (specified by the "compressAt" parameter). The compression is done using the FlutterNativeImage
  // library, which takes in the file path of the image and a quality parameter (defaulting to 50). If the resulting file is smaller than the specified size,
  // the original file is returned. Otherwise, the compressed file is returned as a new VPlatformFile object.
  static Future<VPlatformFile> compressImage({
    required VPlatformFile fileSource,
    int compressAt = 1500 * 1000,
    int quality = 50,
  }) async {
    if (!fileSource.isFromPath) {
      return fileSource;
    }
    VPlatformFile compressedFileSource = fileSource;
    if (compressedFileSource.fileSize > compressAt) {
      // compress only images bigger than 1500 kb
      final compressedFile = await FlutterNativeImage.compressImage(
        fileSource.fileLocalPath!,
        quality: quality,
        //targetWidth: 700,
        // targetHeight: (properties.height! * 700 / properties.width!).round(),
      );
      compressedFileSource =
          VPlatformFile.fromPath(fileLocalPath: compressedFile.path);
    }
    return compressedFileSource;
  }

  static Future<ImageInfo> getImageInfo({
    required VPlatformFile fileSource,
  }) async {
    final Image image = fileSource.isFromBytes
        ? Image.memory(Uint8List.fromList(fileSource.bytes!))
        : Image.file(File(fileSource.fileLocalPath!));
    final completer = Completer<ImageInfo>();
    final listener = ImageStreamListener((info, _) => completer.complete(info));
    image.image.resolve(const ImageConfiguration()).addListener(listener);
    return completer.future;
  }
}
