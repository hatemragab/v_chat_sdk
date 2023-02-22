import 'package:v_chat_message_page/src/page/message_page/states/app_bar_state_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../providers/message_provider.dart';

class LastSeenStateController with VRoomStream {
  final VRoom room;
  final String _cacheKey = "last-seen-";
  DateTime? value;

  final MessageProvider _messageProvider;

  LastSeenStateController(
    this.appBarStateController,
    this.room,
    this._messageProvider,
  ) {
    initRoomStream(
      VChatController.I.nativeApi.streams.roomStream.where(
        (e) => e.roomId == room.id,
      ),
    );
    if (!room.isOnline) {
      updateFromRemote();
    }
  }

  void close() {
    closeRoomStream();
  }

  final AppBarStateController appBarStateController;

  @override
  void onRoomOffline(VRoomOfflineEvent event) {
    updateFromRemote();
  }

  void updateValue(DateTime value) {
    this.value = value;
    appBarStateController.updateLastSeen(value);
  }

  Future<void> updateFromRemote() async {
    await vSafeApiCall<DateTime>(
        request: () async {
          return await _messageProvider.getLastSeenAt(room.peerIdentifier!);
        },
        onSuccess: (response) {
          updateValue(response);
        },
        ignoreTimeoutAndNoInternet: true);
  }
}
