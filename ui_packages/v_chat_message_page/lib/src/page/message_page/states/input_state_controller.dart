import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../models/input_state_model.dart';
import '../message_provider.dart';

class InputStateController {
  late final ValueNotifier<MessageInputModel> inputState;
  final MessageProvider _messageProvider;
  final VRoom _vRoom;

  InputStateController(
    this._vRoom,
    this._messageProvider,
  ) {
    inputState = ValueNotifier<MessageInputModel>(
      MessageInputModel(
        isCloseInput: _vRoom.blockerId != null,
      ),
    );
  }

  void dismiseReply() {
    inputState.value.replyMsg = null;
    inputState.notifyListeners();
  }

  void setReply(VBaseMessage baseMessage) {
    inputState.value.replyMsg = baseMessage;
    inputState.notifyListeners();
  }

  void closeChat() {
    inputState.value.isCloseInput = true;
    inputState.notifyListeners();
  }

  void openChat() {
    inputState.value.isCloseInput = false;
    inputState.notifyListeners();
  }

  void close() {
    inputState.dispose();
  }
}
