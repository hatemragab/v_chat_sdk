import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/image_item.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/video_item.dart';

import '../../../core/core.dart';
import 'file_item.dart';

class MediaItem extends StatelessWidget {
  final VoidCallback onCloseClicked;
  final Function(BaseMediaEditor item) onDelete;
  final Function(BaseMediaEditor item) onCrop;
  final Function(BaseMediaEditor item) onStartDraw;
  final Function(BaseMediaEditor item) onPlayVideo;
  final bool isProcessing;

  final BaseMediaEditor mediaFile;

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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator.adaptive(),
        ],
      );
    }
    if (mediaFile is MediaEditorImage) {
      return ImageItem(
        image: mediaFile as MediaEditorImage,
        onCloseClicked: onCloseClicked,
        onCrop: onCrop,
        onDelete: onDelete,
        onStartDraw: onStartDraw,
      );
    } else if (mediaFile is MediaEditorVideo) {
      return VideoItem(
        video: mediaFile as MediaEditorVideo,
        onCloseClicked: onCloseClicked,
        onPlayVideo: onPlayVideo,
        onDelete: onDelete,
      );
    } else {
      return FileItem(
        file: mediaFile as MediaEditorFile,
        onCloseClicked: onCloseClicked,
        onDelete: onDelete,
      );
    }
  }

  Widget getImage() {
    const BoxFit? fit = null;
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
