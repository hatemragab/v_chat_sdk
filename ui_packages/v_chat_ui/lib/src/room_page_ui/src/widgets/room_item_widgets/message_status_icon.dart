import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/src/core/extension.dart';

class MessageStatusIcon extends StatelessWidget {
  final VBaseMessage vBaseMessage;

  const MessageStatusIcon({
    Key? key,
    required this.vBaseMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.vRoomTheme;
    Widget icon = themeData.vMsgStatusTheme.sendIcon;

    if (vBaseMessage.isSending) {
      themeData.vMsgStatusTheme.pendingIcon;
    }
    if (vBaseMessage.isSendError) {
      icon = themeData.vMsgStatusTheme.refreshIcon;
    } else if (vBaseMessage.seenAt != null) {
      icon = themeData.vMsgStatusTheme.seenIcon;
    } else if (vBaseMessage.deliveredAt != null) {
      icon = themeData.vMsgStatusTheme.deliverIcon;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: icon,
    );
  }
}
