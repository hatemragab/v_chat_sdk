import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/core.dart';

class HorzMediaItem extends StatelessWidget {
  final BaseMediaEditor mediaFile;
  final bool isLoading;

  const HorzMediaItem({
    super.key,
    required this.mediaFile,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 45,
      decoration: !mediaFile.isSelected
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              border: Border.all(color: Colors.red, width: 2),
            ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isLoading && mediaFile is MediaEditorVideo)
            const SizedBox()
          else
            getImage(),
          if (mediaFile is MediaEditorVideo)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  PhosphorIcons.videoCameraFill,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget getImage() {
    const fit = BoxFit.cover;
    if (mediaFile is MediaEditorImage) {
      final m = mediaFile as MediaEditorImage;
      if (m.data.isFromPath) {
        return Image.file(
          File(m.data.fileSource.filePath!),
          fit: fit,
        );
      }
      if (m.data.isFromBytes) {
        return Image.memory(
          Uint8List.fromList(m.data.fileSource.bytes!),
          fit: fit,
        );
      }
    } else if (mediaFile is MediaEditorVideo) {
      final m = mediaFile as MediaEditorVideo;
      if (m.data.isFromPath) {
        return Image.file(
          File(m.data.thumbImage!.fileSource.filePath!),
          fit: fit,
        );
      }
      return Container(
        color: Colors.black,
      );
    }
    return Container(
      color: Colors.black,
    );
  }
}
