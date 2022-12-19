import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_media_editor/src/core/core.dart';

class FileItem extends StatelessWidget {
  final MediaEditorFile file;
  final VoidCallback onCloseClicked;
  final Function(MediaEditorFile item) onDelete;

  const FileItem({
    Key? key,
    required this.file,
    required this.onCloseClicked,
    required this.onDelete,
  }) : super(key: key);

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
                      onPressed: () => onDelete(file),
                      icon: const Icon(
                        PhosphorIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Text(
          file.data.toString(),
        )
      ],
    );
  }
}
