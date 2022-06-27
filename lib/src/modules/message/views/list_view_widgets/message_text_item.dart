import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_chat_sdk/src/models/v_chat_message.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/custom_alert_dialog.dart';

class MessageTextItem extends StatelessWidget {
  final VChatMessage message;
  final bool isSender;

  const MessageTextItem({
    Key? key,
    required this.message,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSender) {
      return InkWell(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: message.content));
          CustomAlert.done(
            context: context,
            msg: VChatAppService.instance
                .getTrans(context)
                .messageCopiedToClipboard(),
          );
        },
        child: VChatAppService.instance.vcBuilder
            .senderTextMessageWidget(context, message.content),
      );
    } else {
      return InkWell(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: message.content));
          CustomAlert.done(
            context: context,
            msg: VChatAppService.instance
                .getTrans(context)
                .messageCopiedToClipboard(),
          );
        },
        child: VChatAppService.instance.vcBuilder
            .receiverTextMessageWidget(context, message.content),
      );
    }
  }
}
