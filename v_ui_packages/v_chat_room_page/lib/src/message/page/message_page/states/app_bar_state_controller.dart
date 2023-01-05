import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../models/app_bare_state_model.dart';
import '../message_provider.dart';

class AppBarStateController with VSocketIntervalStream {
  late final ValueNotifier<MessageAppBarStateModel> appBareState;
  final MessageProvider _messageProvider;
  final VRoom _vRoom;

  AppBarStateController(
    this._vRoom,
    this._messageProvider,
  ) {
    appBareState = ValueNotifier<MessageAppBarStateModel>(
      MessageAppBarStateModel.fromVRoom(
        _vRoom,
      ),
    );
    initSocketIntervalStream(
      VChatController.I.nativeApi.streams.socketIntervalStream,
    );
    _updateAppBareState();
  }

  void updateTitle(String title) {
    appBareState.value.roomTitle = title;
    appBareState.notifyListeners();
  }

  void updateOnline() {
    if (!_vRoom.isThereBlock) {
      appBareState.value.isOnline = true;
      appBareState.notifyListeners();
    }
  }

  void updateImage(String image) {
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

  void close() {
    appBareState.dispose();
    closeSocketIntervalStream();
  }

  void updateOffline() {
    appBareState.value.isOnline = false;
    // appBareState.value.lastSeenAt = null;
    appBareState.notifyListeners();
  }

  @override
  void onIntervalFire() async {
    _updateAppBareState();
  }

  Future<void> _updateAppBareState() async {
    if (!_vRoom.isOnline &&
        _vRoom.roomType.isSingleOrOrder &&
        _vRoom.blockerId == null &&
        appBareState.value.lastSeenAt == null) {
      await vSafeApiCall<DateTime>(
        request: () async {
          return await _messageProvider.getLastSeenAt(_vRoom.peerId!);
        },
        onSuccess: (response) {
          updateLastSeen(response);
        },
      );
    }
  }
}
