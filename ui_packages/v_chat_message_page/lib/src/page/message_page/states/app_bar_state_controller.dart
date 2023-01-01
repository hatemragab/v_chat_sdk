import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/page/message_page/message_provider.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../models/app_bare_state_model.dart';

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
      VChatController.I.nativeApi.remote.socketIo.socketIntervalStream,
    );
    if (!_vRoom.isOnline) {
      _updateAppBareState();
    }
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
    closeSocketIntervalStream();
  }

  void updateOffline() {
    appBareState.value.isOnline = false;
    appBareState.notifyListeners();
  }

  @override
  void onIntervalFire() async {
    if (_vRoom.roomType.isSingleOrOrder) {
      if (!_vRoom.isOnline && appBareState.value.lastSeenAt == null) {
        _updateAppBareState();
      }
    }
  }

  Future<void> _updateAppBareState() async {
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
