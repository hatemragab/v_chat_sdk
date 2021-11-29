import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';

import '../../../../models/v_chat_message.dart';
import '../../../voice_player/views/voice_player.dart';

class MessageVoiceView extends StatelessWidget {
  final VChatMessage _message;
  final bool isSender;

  const MessageVoiceView(this._message, {Key? key, required this.isSender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final att = _message.messageAttachment!;

    if (isSender) {
      return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return VoicePlayer(
                message: _message,
              );
            },
          );
        },
        child: VChatAppService.instance.vcBuilder.senderVoiceMessageWidget(context, att.fileDuration!),
      );
    } else {
      return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return VoicePlayer(
                message: _message,
              );
            },
          );
        },
        child: VChatAppService.instance.vcBuilder.receiverVoiceMessageWidget(context, att.fileDuration!),
      );
    }
  }
}
