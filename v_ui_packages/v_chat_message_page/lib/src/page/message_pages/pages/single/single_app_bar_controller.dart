import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../core/stream_mixin.dart';
import '../../providers/message_provider.dart';

class SingleAppBarController extends ValueNotifier<SingleAppBarStateModel>
    with StreamMix {
  final VRoom vRoom;
  final MessageProvider messageProvider;

  SingleAppBarController({
    required this.vRoom,
    required this.messageProvider,
  }) : super(SingleAppBarStateModel.fromVRoom(vRoom)) {
    _initStreams();
    _autoUpdateLastSeenValue();
  }

  void updateOnline() {
    value.isOnline = true;
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
    closeStreamMix();
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

  void _initStreams() {
    streamsMix.addAll([
      VEventBusSingleton.vEventBus
          .on<VRoomOfflineEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen((_) {
        updateOffline();
      }),
      VEventBusSingleton.vEventBus
          .on<VRoomOnlineEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen((_) {
        updateOnline();
      }),
      VEventBusSingleton.vEventBus
          .on<VUpdateRoomTypingEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen(_updateRoomTyping),
      VEventBusSingleton.vEventBus
          .on<VSingleBlockEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen(_handleOnBlock)
    ]);
  }

  void _autoUpdateLastSeenValue() {
    if (!vRoom.isOnline && value.lastSeenAt == null) {
      updateFromRemote();
    }
  }

  Future<void> updateFromRemote() async {
    await vSafeApiCall<DateTime>(
      request: () async {
        return await messageProvider.getLastSeenAt(value.peerIdentifier);
      },
      onSuccess: (response) {
        value.lastSeenAt = response;
        notifyListeners();
      },
      ignoreTimeoutAndNoInternet: true,
    );
  }

  void _handleOnBlock(VSingleBlockEvent event) {
    if (event.banModel.isThereBan) {
      value.lastSeenAt = null;
      value.isOnline = false;
      notifyListeners();
    } else {
      _autoUpdateLastSeenValue();
    }
  }

  void _updateRoomTyping(VUpdateRoomTypingEvent event) {
    updateTyping(event.typingModel);
  }
}

class SingleAppBarStateModel {
  DateTime? lastSeenAt;
  final String roomTitle;
  final String roomId;
  final String peerIdentifier;
  final String roomImage;
  VSocketRoomTypingModel typingModel;
  bool isOnline;
  bool isSearching;

  SingleAppBarStateModel._({
    required this.roomTitle,
    required this.roomId,
    required this.peerIdentifier,
    required this.roomImage,
    required this.typingModel,
    required this.isOnline,
    required this.isSearching,
  });

  factory SingleAppBarStateModel.fromVRoom(VRoom room) {
    return SingleAppBarStateModel._(
      roomId: room.id,
      typingModel: room.typingStatus,
      isOnline: room.isOnline,
      roomImage: room.thumbImage,
      roomTitle: room.title,
      isSearching: false,
      peerIdentifier: room.peerIdentifier!,
    );
  }

  String? typingText(BuildContext context) {
    return typingModel.inSingleText(context);
  }
}
