import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

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
    final themeData = context.vMessageTheme;
    if (!isMeSender) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: _getIcon(themeData),
    );
  }

  Widget _getIcon(themeData) {
    switch (messageStatus) {
      case MessageEmitStatus.serverConfirm:
        return themeData.vMessageItemBuilder.messageSendingStatus.sendIcon;
      case MessageEmitStatus.error:
        return themeData.vMessageItemBuilder.messageSendingStatus.refreshIcon;
      case MessageEmitStatus.sending:
        return themeData.vMessageItemBuilder.messageSendingStatus.pendingIcon;
    }
  }
}
