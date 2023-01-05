import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../models/input_state_model.dart';
import '../message_provider.dart';

class InputStateController {
  late final ValueNotifier<MessageInputModel> _inputState;

  ValueNotifier<MessageInputModel> get inputState => _inputState;

  final MessageProvider _messageProvider;
  final VRoom _vRoom;

  InputStateController(
    this._vRoom,
    this._messageProvider,
  ) {
    _inputState = ValueNotifier<MessageInputModel>(
      MessageInputModel(
        isCloseInput: _vRoom.blockerId != null,
      ),
    );
    if (_vRoom.roomType.isGroup) {
      _checkStatus(_vRoom.id);
    }
  }

  void dismissReply() {
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

  void _checkStatus(String roomId) async {
    await vSafeApiCall<bool>(
      request: () async {
        return await _messageProvider.checkGroupStatus(roomId);
      },
      onSuccess: (isMeOut) {
        closeChat();
      },
    );
  }
}
