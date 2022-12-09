import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../../v_chat_ui.dart';

class MediaItem extends StatelessWidget {
  final VoidCallback onCloseClicked;

  final Function(BaseMediaEditor item) onDelete;
  final Function(BaseMediaEditor item) onCrop;
  final Function(BaseMediaEditor item) onStartDraw;
  final Function(BaseMediaEditor item) onPlayVideo;
  final bool isActive;

  final BaseMediaEditor mediaFile;

  const MediaItem({
    super.key,
    required this.mediaFile,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onCrop,
    required this.onStartDraw,
    required this.isActive,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: onCloseClicked,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: isActive ? () => onDelete(mediaFile) : null,
                      icon: const Icon(
                        PhosphorIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    if (mediaFile is MediaEditorVideo)
                      const SizedBox()
                    else
                      IconButton(
                        iconSize: 30,
                        onPressed: isActive ? () => onCrop(mediaFile) : null,
                        icon: const Icon(
                          PhosphorIcons.crop,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(
                      width: 3,
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: isActive ? () => onStartDraw(mediaFile) : null,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        if (!isActive && mediaFile is MediaEditorVideo)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator.adaptive(),
              ],
            ),
          )
        else
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                getImage(),
                if (mediaFile is MediaEditorVideo)
                  InkWell(
                    onTap: () => onPlayVideo(mediaFile),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: const Icon(
                            PhosphorIcons.playFill,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
      ],
    );
  }

  Widget getImage() {
    final BoxFit? fit = null;
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
