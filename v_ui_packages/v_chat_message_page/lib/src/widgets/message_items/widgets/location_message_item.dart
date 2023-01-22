import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class LocationMessageItem extends StatelessWidget {
  final VLocationMessage message;

  const LocationMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          PhosphorIcons.mapPin,
          size: 44,
        ),
        Expanded(
          child: ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            dense: true,
            title: message.data.linkPreviewData.title.toString().text,
            subtitle: message.data.linkPreviewData.desc
                .toString()
                .text
                .maxLine(2)
                .overflowEllipsis,
          ),
        )
      ],
    );
  }
}
