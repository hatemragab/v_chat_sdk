// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

import '../group/message_group_status_controller.dart';

class MessageBroadcastStatusController
    extends ValueNotifier<MessageStatusState> {
  MessageBroadcastStatusController(this.message) : super(MessageStatusState()) {
    getData();
  }

  final VBaseMessage message;

  VChatLoadingState state = VChatLoadingState.ideal;
  VVoiceMessageController? voiceMessageController;
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
        x.seen.addAll(
            await VChatController.I.roomApi.getMessageStatusForBroadcast(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: true,
        ));
        x.deliver.addAll(
            await VChatController.I.roomApi.getMessageStatusForBroadcast(
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

  void close() {
    voiceMessageController?.dispose();
    dispose();
  }
}
