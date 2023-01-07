import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../models/input_state_model.dart';
import '../message_provider.dart';

class InputStateController extends ValueNotifier<MessageInputModel> {
  final MessageProvider _messageProvider;
  final VRoom _vRoom;

  InputStateController(
    this._vRoom,
    this._messageProvider,
  ) : super(MessageInputModel(
          isCloseInput: _vRoom.blockerId != null,
        )) {
    if (_vRoom.roomType.isGroup) {
      _checkStatus(_vRoom.id);
    }
  }

  void dismissReply() {
    value.replyMsg = null;
    notifyListeners();
  }

  void setReply(VBaseMessage baseMessage) {
    value.replyMsg = baseMessage;
    notifyListeners();
  }

  void closeChat() {
    value.isCloseInput = true;
    notifyListeners();
  }

  void openChat() {
    value.isCloseInput = false;
    notifyListeners();
  }

  void close() {
    dispose();
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

  void hide() {
    value.isHidden = true;
    notifyListeners();
  }

  void unHide() {
    value.isHidden = false;
    notifyListeners();
  }
}
