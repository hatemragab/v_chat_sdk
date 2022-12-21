import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class FileItem extends StatelessWidget {
  final VMediaFileRes file;
  final VoidCallback onCloseClicked;
  final Function(VMediaFileRes item) onDelete;

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
        Align(
          alignment: Alignment.center,
          child: Text(
            file.data.name.toString(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800),
          ),
        )
      ],
    );
  }
}
