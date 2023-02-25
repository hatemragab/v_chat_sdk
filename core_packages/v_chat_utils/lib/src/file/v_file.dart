// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
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

  static Future<String> _downloadFileForWeb(
    VPlatformFileSource fileSource,
  ) async {
    final bytes = (await http.get(
      Uri.parse(fileSource.url!),
    ))
        .bodyBytes;
    return await FileSaver.instance.saveFile(
      fileSource.name,
      bytes,
      fileSource.mimeType.toString(),
    );
  }

  ///make sure you ask for storage permissions
  static Future<String> saveFileToPublicPath({
    required VPlatformFileSource fileAttachment,
    required String appName,
  }) async {
    if (VPlatforms.isMobile) {
      final newFilePath = (await _downloadPath(appName)) + fileAttachment.name;
      final file = File(newFilePath);
      if (!file.existsSync()) {
        file.createSync();
      } else {
        return file.path;
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
    return _downloadFileForWeb(fileAttachment);
  }

  static Future<VMessageImageData?> getVideoThumb(
      {required VPlatformFileSource fileSource,
      int maxWidth = 600,
      int quality = 50}) async {
    if (fileSource.isFromBytes || fileSource.isFromUrl) return null;
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: fileSource.filePath!,
      maxWidth: maxWidth,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: quality,
    );
    if (thumbPath == null) return null;
    final thumbImageData = await getImageInfo(
        fileSource: VPlatformFileSource.fromPath(
      filePath: thumbPath,
    ));
    return VMessageImageData(
      fileSource: VPlatformFileSource.fromPath(filePath: thumbPath),
      width: thumbImageData.image.width,
      height: thumbImageData.image.height,
    );
  }

  ///only [VPlatformFileSource.fromPath(filePath: filePath)] will work!
  static Future<int?> getVideoDurationMill(VPlatformFileSource file) async {
    if (file.isFromBytes) {
      return null;
      // final controller = VideoPlayerController.contentUri(
      //   Uri.dataFromBytes(file.bytes!),
      // );
      // await controller.initialize();
      // final value = controller.value.duration.inMilliseconds;
      // unawaited(controller.dispose());
      // return value;
    } else if (file.isFromPath) {
      final controller = VideoPlayerController.file(
        File(file.filePath!),
      );
      await controller.initialize();
      final value = controller.value.duration.inMilliseconds;
      unawaited(controller.dispose());
      return value;
    }
    return 000;
  }

  static Future<VPlatformFileSource> compressImage({
    required VPlatformFileSource fileSource,
    int compressAt = 1500 * 1000,
    int quality = 50,
  }) async {
    if (!fileSource.isFromPath) {
      return fileSource;
    }
    VPlatformFileSource compressedFileSource = fileSource;
    if (compressedFileSource.fileSize > compressAt) {
      // compress only images bigger than 1500 kb
      final compressedFile = await FlutterNativeImage.compressImage(
        fileSource.filePath!,
        quality: quality,
        //targetWidth: 700,
        // targetHeight: (properties.height! * 700 / properties.width!).round(),
      );
      compressedFileSource =
          VPlatformFileSource.fromPath(filePath: compressedFile.path);
    }
    return compressedFileSource;
  }

  static Future<ImageInfo> getImageInfo({
    required VPlatformFileSource fileSource,
  }) {
    late final Image image;
    if (fileSource.isFromBytes) {
      image = Image.memory(Uint8List.fromList(fileSource.bytes!));
    } else {
      image = Image.file(File(fileSource.filePath!));
    }
    final c = Completer<ImageInfo>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo i, bool _) {
        c.complete(i);
      }),
    );
    return c.future;
  }
}
