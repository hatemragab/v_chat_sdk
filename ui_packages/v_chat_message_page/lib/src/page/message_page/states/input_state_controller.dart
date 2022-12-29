import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../models/input_state_model.dart';

class InputStateController {
  late final ValueNotifier<MessageInputModel> inputState;

  InputStateController(bool isChatClosed) {
    inputState = ValueNotifier<MessageInputModel>(
      MessageInputModel(
        isCloseInput: isChatClosed,
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
