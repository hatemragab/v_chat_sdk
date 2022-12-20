import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_media_editor/src/core/core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ImageItem extends StatelessWidget {
  final VMediaEditorImage image;
  final VoidCallback onCloseClicked;
  final Function(VMediaEditorImage item) onDelete;
  final Function(VMediaEditorImage item) onCrop;
  final Function(VMediaEditorImage item) onStartDraw;

  const ImageItem(
      {Key? key,
      required this.image,
      required this.onCloseClicked,
      required this.onDelete,
      required this.onCrop,
      required this.onStartDraw})
      : super(key: key);

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
                      onPressed: () => onDelete(image),
                      icon: const Icon(
                        PhosphorIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onCrop(image),
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
                      onPressed: () => onStartDraw(image),
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
        Expanded(
          child: VPlatformCacheImageWidget(
            source: image.data.fileSource,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
