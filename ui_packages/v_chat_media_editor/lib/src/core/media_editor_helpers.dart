import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mime_type/mime_type.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:video_player/video_player.dart';

abstract class MediaEditorHelpers {
  ///get file type [MediaEditorType]
  static MediaEditorType getTypeFromName(String name) {
    return _getMediaType(name);
  }

  static MediaEditorType _getMediaType(String name) {
    final mimeStr = mime(name);
    if (mimeStr == null) return MediaEditorType.file;
    final fileType = mimeStr.split('/').first;
    if (fileType == "video") {
      return MediaEditorType.video;
    }
    if (fileType == "image") {
      return MediaEditorType.image;
    }
    return MediaEditorType.file;
  }

  ///get image info like width and height
  static Future<ImageInfo> getImageInfo({
    List<int>? bytes,
    String? path,
  }) {
    late final Image image;
    if (kIsWeb) {
      image = Image.memory(Uint8List.fromList(bytes!));
    } else {
      image = Image.file(File(path!));
    }
    final c = Completer<ImageInfo>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo i, bool _) {
        c.complete(i);
      }),
    );
    return c.future;
  }

  ///only [VPlatformFileSource.fromPath(filePath: filePath)] will work!
  static Future<int> getVideoDurationMill(VPlatformFileSource file) async {
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

enum MediaEditorType { image, video, file }
