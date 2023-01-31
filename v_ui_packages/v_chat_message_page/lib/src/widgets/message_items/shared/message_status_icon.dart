import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_message_page.dart';
import '../../../core/types.dart';

class MessageStatusIconDataModel {
  final bool isMeSender;
  final bool isSeen;
  final bool isDeliver;
  final VMessageEmitStatus emitStatus;

  const MessageStatusIconDataModel({
    required this.isMeSender,
    required this.isSeen,
    required this.isDeliver,
    required this.emitStatus,
  });
}

class MessageStatusIcon extends StatelessWidget {
  final VoidCallback? onReSend;
  final MessageStatusIconDataModel model;

  const MessageStatusIcon({
    Key? key,
    required this.model,
    this.onReSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.vMessageTheme.messageSendingStatus;
    if (!model.isMeSender) {
      return const SizedBox.shrink();
    }
    if (model.isSeen) {
      return _getBody(themeData.seenIcon);
    }
    if (model.isDeliver) {
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
    switch (model.emitStatus) {
      case VMessageEmitStatus.serverConfirm:
        return themeData.sendIcon;
      case VMessageEmitStatus.error:
        return InkWell(
          onTap: () {
            if (onReSend != null) {
              onReSend!();
            }
          },
          child: themeData.refreshIcon,
        );
      case VMessageEmitStatus.sending:
        return themeData.pendingIcon;
    }
  }
}
