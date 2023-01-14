import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
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
    return VVoiceMessageView(
      controller: voiceController(message)!,
      backgroundColor: Colors.transparent,
      activeSliderColor: Colors.white,
    );
  }
}
