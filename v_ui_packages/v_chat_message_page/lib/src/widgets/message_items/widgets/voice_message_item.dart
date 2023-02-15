import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

class VoiceMessageItem extends StatelessWidget {
  final VVoiceMessage message;
  final VVoiceMessageController? Function(VBaseMessage message) voiceController;

  const VoiceMessageItem({
    Key? key,
    required this.message,
    required this.voiceController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //   print(message.data.fileSource.url);
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: VVoiceMessageView(
        controller: voiceController(message)!,
        notActiveSliderColor: context.vMessageTheme
            .messageItemHolderColor(
              context,
              message.isMeSender,
              context.isDark,
            )
            .withOpacity(.3),
        activeSliderColor: context.isDark ? Colors.green : Colors.red,
      ),
    );
  }
}
