import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageStatusIcon extends StatelessWidget {
  final MessageSendingStatusEnum messageStatus;
  final bool isMeSender;
  final bool isSeen;
  final bool isDeliver;

  const MessageStatusIcon({
    Key? key,
    required this.isMeSender,
    required this.messageStatus,
    required this.isDeliver,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.vMessageTheme;
    if (!isMeSender) {
      return const SizedBox.shrink();
    }
    Widget icon = themeData.vMessageItemBuilder.messageSendingStatus.sendIcon;
    if (messageStatus.isSending) {
      themeData.vMessageItemBuilder.messageSendingStatus.pendingIcon;
    }
    if (messageStatus.isSendError) {
      icon = themeData.vMessageItemBuilder.messageSendingStatus.refreshIcon;
    } else if (isSeen) {
      icon = themeData.vMessageItemBuilder.messageSendingStatus.seenIcon;
    } else if (isDeliver) {
      icon = themeData.vMessageItemBuilder.messageSendingStatus.deliverIcon;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: icon,
    );
  }
}
