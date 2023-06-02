// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/image_item.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/video_item.dart';

import '../../../../v_chat_media_editor.dart';
import 'file_item.dart';

class MediaItem extends StatelessWidget {
  final VoidCallback onCloseClicked;
  final Function(VBaseMediaRes item) onDelete;
  final Function(VBaseMediaRes item) onCrop;
  final Function(VBaseMediaRes item) onStartDraw;
  final Function(VBaseMediaRes item) onPlayVideo;
  final bool isProcessing;

  final VBaseMediaRes mediaFile;

  const MediaItem({
    super.key,
    required this.mediaFile,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onCrop,
    required this.onStartDraw,
    required this.isProcessing,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    if (isProcessing) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(),
        ],
      );
    }
    if (mediaFile is VMediaImageRes) {
      return ImageItem(
        image: mediaFile as VMediaImageRes,
        onCloseClicked: onCloseClicked,
        onCrop: onCrop,
        onDelete: onDelete,
        onStartDraw: onStartDraw,
      );
    } else if (mediaFile is VMediaVideoRes) {
      return VideoItem(
        video: mediaFile as VMediaVideoRes,
        onCloseClicked: onCloseClicked,
        onPlayVideo: onPlayVideo,
        onDelete: onDelete,
      );
    } else {
      return FileItem(
        file: mediaFile as VMediaFileRes,
        onCloseClicked: onCloseClicked,
        onDelete: onDelete,
      );
    }
  }

  Widget getImage() {
    const BoxFit? fit = null;
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
    );
  }
}
