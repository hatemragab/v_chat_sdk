import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../v_chat_ui.dart';

class PlatformsImage extends StatelessWidget {
  const PlatformsImage({super.key,
    required this.height,
    required this.width,
    required this.fit,
    required this.platformImage,
  });

  final double? height;
  final double? width;
  final MediaEditorPlatformFile platformImage;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.memory(
        platformImage.bytes!,
        height: height,
        width: width,
        fit: fit,
      );
    }
    return Image.file(
      File(platformImage.path!),
      height: height,
      width: width,
      fit: fit,
    );
  }
}
