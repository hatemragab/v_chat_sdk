import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../models/app_bare_state_model.dart';

class AppBarStateController {
  late final ValueNotifier<MessageAppBarStateModel> appBareState;

  AppBarStateController(VRoom vRoom) {
    appBareState = ValueNotifier<MessageAppBarStateModel>(
      MessageAppBarStateModel.fromVRoom(
        vRoom,
      ),
    );
  }

  void updateTitle(String title) {
    appBareState.value.roomTitle = title;
    appBareState.notifyListeners();
  }

  void updateOnline() {
    appBareState.value.isOnline = true;
    appBareState.notifyListeners();
  }

  void updateImage(VFullUrlModel image) {
    appBareState.value.roomImage = image;
    appBareState.notifyListeners();
  }

  void updateTyping(VSocketRoomTypingModel typingModel) {
    appBareState.value.typingModel = typingModel;
    appBareState.notifyListeners();
  }

  void updateLastSeen(DateTime lastSeenAt) {
    appBareState.value.lastSeenAt = lastSeenAt;
    appBareState.notifyListeners();
  }

  void updateMemberCount(int count) {
    appBareState.value.memberCount = count;
    appBareState.notifyListeners();
  }

  close() {
    appBareState.dispose();
  }

  void updateOffline() {
    appBareState.value.isOnline = false;
    appBareState.notifyListeners();
  }
}
