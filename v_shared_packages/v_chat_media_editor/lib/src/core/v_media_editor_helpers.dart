import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VMediaEditorHelpers {
  ///get file type [MediaEditorType]
  VSupportedFilesType getTypeFromName(String name) {
    return _getMediaType(name);
  }

  VSupportedFilesType _getMediaType(String name) {
    final mimeStr = mime(name);
    if (mimeStr == null) return VSupportedFilesType.file;
    final fileType = mimeStr.split('/').first;
    if (fileType == "video") {
      return VSupportedFilesType.video;
    }
    if (fileType == "image") {
      return VSupportedFilesType.image;
    }
    return VSupportedFilesType.file;
  }

  ///get image info like width and height
  Future<ImageInfo> getImageInfo({
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

  Future<VMessageImageData?> getVideoThumb({
    required VPlatformFileSource fileSource,
  }) async {
    if (fileSource.isFromBytes || fileSource.isFromUrl) return null;
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: fileSource.filePath!,
      maxWidth: 600,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
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

  Future<VPlatformFileSource> compressIoImage({
    required VPlatformFileSource fileSource,
  }) async {
    if (!fileSource.isFromPath) {
      return fileSource;
    }
    VPlatformFileSource compressedFileSource = fileSource;
    if (compressedFileSource.fileSize > 1500 * 1000) {
      // compress only images bigger than 1500 kb
      final compressedFile = await FlutterNativeImage.compressImage(
        fileSource.filePath!,
        quality: 50,
        //targetWidth: 700,
        // targetHeight: (properties.height! * 700 / properties.width!).round(),
      );
      compressedFileSource =
          VPlatformFileSource.fromPath(filePath: compressedFile.path);
    }
    return compressedFileSource;
  }

  ///only [VPlatformFileSource.fromPath(filePath: filePath)] will work!
  Future<int> getVideoDurationMill(VPlatformFileSource file) async {
    if (file.isFromBytes) {
      return 000;
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
}
