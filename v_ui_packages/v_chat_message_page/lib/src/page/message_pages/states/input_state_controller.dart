// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../models/input_state_model.dart';

class InputStateController extends ValueNotifier<MessageInputModel> {
  final VRoom vRoom;

  InputStateController(
    this.vRoom,
  ) : super(MessageInputModel(isCloseInput: false)) {
    // if (_vRoom.roomType.isGroup) {
    //   _checkStatus(_vRoom.id);
    // }
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

  // void _checkStatus(String roomId) async {
  //   await vSafeApiCall<bool>(
  //     request: () async {
  //       return await _messageProvider.checkGroupStatus(roomId);
  //     },
  //     onSuccess: (isMeOut) {
  //       if (isMeOut) {
  //         closeChat();
  //       }
  //     },
  //   );
  // }

  void hide() {
    value.isHidden = true;
    notifyListeners();
  }

  void unHide() {
    value.isHidden = false;
    notifyListeners();
  }
}
