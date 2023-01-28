import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class RoomItemMsg extends StatelessWidget {
  final bool isBold;
  final VBaseMessage message;

  const RoomItemMsg({
    Key? key,
    required this.message,
    required this.isBold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.vRoomTheme;
    if (message.messageType.isAllDeleted) {
      return VTrans.of(context).labels.messageHasBeenDeleted.text.italic;
    }
    if (message.isDeleted) {
      return message.getMessageText(context).text.lineThrough;
    }
    if (isBold) {
      return VTextParserWidget(
        text: message.getMessageText(context),
        enableTabs: false,
        onMentionPress: (userId) {},
        maxLines: 1,
        textStyle: theme.unSeenLastMessageTextStyle,
      );
    }
    return VTextParserWidget(
      text: message.getMessageText(context),
      enableTabs: false,
      onMentionPress: (userId) {},
      maxLines: 1,
      textStyle: theme.seenLastMessageTextStyle,
    );
  }
}
