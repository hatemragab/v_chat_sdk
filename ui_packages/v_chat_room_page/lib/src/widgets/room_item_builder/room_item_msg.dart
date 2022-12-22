import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/chat.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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
    final theme = context.vRoomTheme.vChatItemBuilder;
    if (isBold) {
      return VTextParserWidget(
        text: msg,
        enableTabs: false,
        parseMentions: true,
        maxLines: 1,
        style: theme.unSeenLastMessageTextStyle,
      );
    }
    return VTextParserWidget(
      text: msg,
      enableTabs: false,
      parseMentions: true,
      maxLines: 1,
      style: theme.seenLastMessageTextStyle,
    );
  }
}
