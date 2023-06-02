// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

class MessageStatusState {
  final List<VMessageStatusModel> seen = [];
  final List<VMessageStatusModel> deliver = [];
}

class MessageGroupStatusController extends ValueNotifier<MessageStatusState> {
  final VBaseMessage message;

  MessageGroupStatusController(this.message) : super(MessageStatusState()) {
    getData();
  }

  VChatLoadingState state = VChatLoadingState.ideal;
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

  void getData() async {
    await vSafeApiCall<MessageStatusState>(
      onLoading: () {
        state = VChatLoadingState.loading;
        notifyListeners();
      },
      request: () async {
        final x = MessageStatusState();
        x.seen.addAll(await VChatController.I.roomApi.getMessageStatusForGroup(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: true,
        ));
        x.deliver
            .addAll(await VChatController.I.roomApi.getMessageStatusForGroup(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: false,
        ));
        return x;
      },
      onSuccess: (response) {
        value = response;
        state = VChatLoadingState.success;
        notifyListeners();
      },
      onError: (exception, trace) {
        state = VChatLoadingState.error;
        notifyListeners();
      },
    );
  }
}
