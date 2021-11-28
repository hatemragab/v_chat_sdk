import 'package:flutter/material.dart';
import '../../../../models/v_chat_message.dart';
import '../../../../services/v_chat_app_service.dart';

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
      return VChatAppService.instance.vcBuilder
          .senderTextMessageWidget(context, message.content);
    } else {
      return VChatAppService.instance.vcBuilder
          .receiverTextMessageWidget(context, message.content);
    }
  }

}
