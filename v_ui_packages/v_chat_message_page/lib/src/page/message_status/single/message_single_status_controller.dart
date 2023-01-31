import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/src/models/v_message/base_message/v_base_message.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_voice_player/src/voice_message_controller.dart';

class MessageSingleStatusController extends ValueNotifier {
  MessageSingleStatusController() : super([]);
  VVoiceMessageController? voiceMessageController;

  void close() {
    voiceMessageController?.dispose();
    dispose();
  }

  VVoiceMessageController? getVoiceController(VBaseMessage message) {
    if (message is VVoiceMessage && voiceMessageController == null) {
      voiceMessageController = VVoiceMessageController(
        id: message.localId,
        audioSrc: message.data.fileSource,
        maxDuration: message.data.durationObj,
      );
      return voiceMessageController;
    } else if (message is VVoiceMessage && voiceMessageController != null) {
      return voiceMessageController;
    }
    return null;
  }
}
