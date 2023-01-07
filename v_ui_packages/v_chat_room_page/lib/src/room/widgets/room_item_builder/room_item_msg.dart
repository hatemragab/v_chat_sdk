import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../shared/widgets/text_parser_widget.dart';

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
    final theme = context.vRoomTheme.vChatItemBuilder;
    if (message.messageType.isAllDeleted) {
      return "Message has been deleted".text.italic;
    }
    if (message.isDeleted) {
      return message.getTextTrans.text.lineThrough;
    }
    if (isBold) {
      return VTextParserWidget(
        text: message.getTextTrans,
        enableTabs: false,
        onMentionPress: (userId) {},
        maxLines: 1,
        textStyle: theme.unSeenLastMessageTextStyle,
      );
    }
    return VTextParserWidget(
      text: message.getTextTrans,
      enableTabs: false,
      onMentionPress: (userId) {},
      maxLines: 1,
      textStyle: theme.seenLastMessageTextStyle,
    );
  }
}
