import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/chat.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageStatusIcon extends StatelessWidget {
  final VBaseMessage vBaseMessage;

  const MessageStatusIcon({
    Key? key,
    required this.vBaseMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.vRoomTheme;
    Widget icon = themeData.vChatItemBuilder.lastMessageStatus.sendIcon;

    if (vBaseMessage.messageStatus.isSending) {
      themeData.vChatItemBuilder.lastMessageStatus.pendingIcon;
    }
    if (vBaseMessage.messageStatus.isSendError) {
      icon = themeData.vChatItemBuilder.lastMessageStatus.refreshIcon;
    } else if (vBaseMessage.seenAt != null) {
      icon = themeData.vChatItemBuilder.lastMessageStatus.seenIcon;
    } else if (vBaseMessage.deliveredAt != null) {
      icon = themeData.vChatItemBuilder.lastMessageStatus.deliverIcon;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: icon,
    );
  }
}
