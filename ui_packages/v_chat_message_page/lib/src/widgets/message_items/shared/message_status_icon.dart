import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
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
    final themeData =
        context.vMessageTheme.vMessageItemBuilder.messageSendingStatus;
    if (!isMeSender) {
      return const SizedBox.shrink();
    }
    if (isSeen) {
      return _getBody(themeData.seenIcon);
    }
    if (isDeliver) {
      return _getBody(themeData.deliverIcon);
    }
    return _getBody(
      _getIcon(themeData),
    );
  }

  Widget _getBody(Widget icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: icon,
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
