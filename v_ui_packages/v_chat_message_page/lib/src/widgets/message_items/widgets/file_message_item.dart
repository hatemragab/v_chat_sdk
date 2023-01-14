import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class FileMessageItem extends StatelessWidget {
  final VFileMessage message;

  const FileMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.download_outlined,
          size: 44,
        ),
        Expanded(
          child: ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            dense: true,
            title: message.data.fileSource.name.text,
            subtitle: message.data.fileSource.readableSize.text,
          ),
        )
      ],
    );
  }
}
