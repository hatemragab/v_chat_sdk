import 'package:flutter/material.dart';
import 'package:v_chat_ui/src/core/extension.dart';
import 'package:v_chat_ui/src/message_page_ui/src/widgets/shared/text_parser_widget.dart';

class RoomItemMsg extends StatelessWidget {
  final String msg;
  final bool isBold;

  const RoomItemMsg({
    Key? key,
    required this.msg,
    required this.isBold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isBold) {
      return TextParserWidget(
        text: msg,
        enableTabs: false,
        parseMentions: true,
        maxLines: 1,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w500,
          color: context.isDark ? Colors.white : Colors.black,
        ),
      );
    }
    return TextParserWidget(
      text: msg,
      enableTabs: false,
      parseMentions: true,
      maxLines: 1,
      style: const TextStyle(
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
