import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../models/app_bare_state_model.dart';
import '../message_provider.dart';

class AppBarStateController extends ValueNotifier<MessageAppBarStateModel>
    with VSocketIntervalStream {
  final MessageProvider _messageProvider;
  final VRoom _vRoom;

  AppBarStateController(
    this._vRoom,
    this._messageProvider,
  ) : super(MessageAppBarStateModel.fromVRoom(_vRoom)) {
    initSocketIntervalStream(
      VChatController.I.nativeApi.streams.socketIntervalStream,
    );
    _updateAppBareState();
  }

  void updateTitle(String title) {
    value.roomTitle = title;
    notifyListeners();
  }
  void setMemberCount(int count) {
      value.memberCount = count;
      notifyListeners();
  }
  void updateOnline() {
    if (!_vRoom.isThereBlock) {
      value.isOnline = true;
      notifyListeners();
    }
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
    closeSocketIntervalStream();
  }

  void updateOffline() async {
    if (value.isOnline) {
      await vSafeApiCall<DateTime>(
        request: () async {
          return await _messageProvider.getLastSeenAt(_vRoom.peerIdentifier!);
        },
        onSuccess: (response) {
          updateLastSeen(response);
        },
      );
    }
    value.isOnline = false;
    notifyListeners();
  }

  @override
  void onIntervalFire() async {
    _updateAppBareState();
  }

  Future<void> _updateAppBareState() async {
    if (!_vRoom.isOnline &&
        _vRoom.roomType.isSingleOrOrder &&
        _vRoom.blockerId == null &&
        value.lastSeenAt == null) {
      await vSafeApiCall<DateTime>(
        request: () async {
          return await _messageProvider.getLastSeenAt(_vRoom.peerIdentifier!);
        },
        onSuccess: (response) {
          updateLastSeen(response);
        },
      );
    }
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
