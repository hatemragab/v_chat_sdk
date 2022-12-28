import 'package:flutter/material.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class MessageStatusIcon extends StatelessWidget {
  final MessageEmitStatus messageStatus;
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
    final themeData = context.vRoomTheme.vChatItemBuilder.lastMessageStatus;
    if (!isMeSender) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: _getIcon(themeData),
    );
  }

  Widget _getIcon(VMsgStatusTheme themeData) {
    switch (messageStatus) {
      case MessageEmitStatus.serverConfirm:
        return themeData.sendIcon;
      case MessageEmitStatus.error:
        return themeData.refreshIcon;
      case MessageEmitStatus.sending:
        return themeData.pendingIcon;
    }
  }
}
