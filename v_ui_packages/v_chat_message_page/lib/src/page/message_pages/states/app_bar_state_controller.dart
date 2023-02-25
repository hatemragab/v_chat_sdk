// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import '../../../models/app_bare_state_model.dart';

class AppBarStateController extends ValueNotifier<MessageAppBarStateModel> {
  final VRoom vRoom;

  AppBarStateController(
    this.vRoom,
  ) : super(MessageAppBarStateModel.fromVRoom(vRoom));

  void updateTitle(String title) {
    value.roomTitle = title;
    notifyListeners();
  }

  void setMemberCount(int count) {
    value.memberCount = count;
    notifyListeners();
  }

  void updateOnline() {
    value.isOnline = true;
    notifyListeners();
  }

  void updateImage(String image) {
    value.roomImage = image;
    notifyListeners();
  }

  void updateTyping(VSocketRoomTypingModel typingModel) {
    value.typingModel = typingModel;
    notifyListeners();
  }

  void updateLastSeen(DateTime lastSeenAt) {
    value.lastSeenAt = lastSeenAt;
    notifyListeners();
  }

  void close() {
    dispose();
  }

  void updateOffline() async {
    value.isOnline = false;
    notifyListeners();
  }

  void onOpenSearch() {
    value.isSearching = true;
    notifyListeners();
  }

  void onCloseSearch() {
    value.isSearching = false;
    notifyListeners();
  }
}
