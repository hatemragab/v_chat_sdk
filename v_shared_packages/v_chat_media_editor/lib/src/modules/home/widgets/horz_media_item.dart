// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../v_chat_media_editor.dart';

class HorizontalMediaItem extends StatelessWidget {
  final VBaseMediaRes mediaFile;
  final bool isLoading;

  const HorizontalMediaItem({
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
          if (isLoading && mediaFile is VMediaVideoRes)
            const SizedBox()
          else
            getImage(),
          if (mediaFile is VMediaVideoRes)
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
    if (mediaFile is VMediaImageRes) {
      final m = mediaFile as VMediaImageRes;
      if (m.data.isFromPath) {
        return Image.file(
          File(m.data.fileSource.fileLocalPath!),
          fit: fit,
        );
      }
      if (m.data.isFromBytes) {
        return Image.memory(
          Uint8List.fromList(m.data.fileSource.bytes!),
          fit: fit,
        );
      }
    } else if (mediaFile is VMediaVideoRes) {
      final m = mediaFile as VMediaVideoRes;
      if (m.data.isFromPath) {
        return Image.file(
          File(m.data.thumbImage!.fileSource.fileLocalPath!),
          fit: fit,
        );
      }
      return Container(
        color: Colors.black,
      );
    }
    return Container(
      color: Colors.black,
      child: const Icon(
        PhosphorIcons.file,
        color: Colors.white,
      ),
    );
  }
}
