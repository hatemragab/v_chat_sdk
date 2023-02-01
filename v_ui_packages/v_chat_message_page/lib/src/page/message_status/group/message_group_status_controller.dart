import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

class MessageGroupStatusState {
  final List<VMessageStatusModel> seen = [];
  final List<VMessageStatusModel> deliver = [];
}

class MessageGroupStatusController
    extends ValueNotifier<MessageGroupStatusState> {
  final VBaseMessage message;

  MessageGroupStatusController(this.message)
      : super(MessageGroupStatusState()) {
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
    await vSafeApiCall<MessageGroupStatusState>(
      onLoading: () {
        state = VChatLoadingState.loading;
        notifyListeners();
      },
      request: () async {
        final x = MessageGroupStatusState();
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
