// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

class MessageSingleStatusController {
  VVoiceMessageController? voiceMessageController;

  void close() {
    voiceMessageController?.dispose();
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
