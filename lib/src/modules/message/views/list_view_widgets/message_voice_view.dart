import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import 'package:v_chat_sdk/src/utils/utils.dart';
import 'package:v_chat_sdk/src/utils/v_chat_extentions.dart';

import '../../../../models/v_chat_message.dart';
import '../../../voice_player/views/voice_player.dart';

class MessageVoiceView extends StatelessWidget {
  final VChatMessage _message;
  final bool isSender;

  const MessageVoiceView(this._message, {Key? key, required this.isSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final att = _message.messageAttachment!;

    final isDark = context.isDark;
    return VChatAppService.instance.vcBuilder
        .voiceSender(context, att.fileDuration!);
    // if (isDark) {
    //   return VChatAppService.instance.vcBuilder
    //       .voiceSenderDark(att.fileDuration!);
    // } else {
    //   return VChatAppService.instance.vcBuilder
    //       .voiceSenderLight(att.fileDuration!);
    // }

    // if (context.isDark) {
    //   return builderVoiceSenderDark(att.fileDuration!);
    // } else {
    //   print("Light");
    //   return builderVoiceSenderLight(att.fileDuration!);
    // }
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSender
              ? isDark
                  ? Colors.grey[300]
                  : Colors.tealAccent
              : isDark
                  ? Colors.black45
                  : const Color(0xff876969),
        ),
        height: 40,
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.play_circle,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            att.fileDuration!.cap
          ],
        ),
      ),
    );
  }
}
