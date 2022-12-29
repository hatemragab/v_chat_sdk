import 'dart:async';

import '../../v_chat_sdk_core.dart';

mixin VMessageStream {
  late final StreamSubscription<VMessageEvents> _messagesStream;

  void initMessageStream(Stream<VMessageEvents> stream) {
    _messagesStream = stream.listen(
      (event) {
        if (event is VInsertMessageEvent) {
          return onNewMsg(event);
        }
        if (event is VUpdateMessageEvent) {
          return onUpdateMsg(event);
        }
        if (event is VDeleteMessageEvent) {
          return onDeleteMsg(event);
        }
        if (event is VUpdateMessageTypeEvent) {
          return onUpdateMsgType(event);
        }

        if (event is VUpdateMessageStatusEvent) {
          return onUpdateMsgStatus(event);
        }

        if (event is VUpdateMessageSeenEvent) {
          return onSeenAllMgs(event);
        }
        if (event is VUpdateMessageDeliverEvent) {
          return onDeliverAllMgs(event);
        }
      },
    );
  }

  void closeMessageStream() {
    _messagesStream.cancel();
  }

  void onNewMsg(VInsertMessageEvent event);

  void onUpdateMsg(VUpdateMessageEvent event);

  void onDeleteMsg(VDeleteMessageEvent event);

  void onUpdateMsgType(VUpdateMessageTypeEvent event);

  void onUpdateMsgStatus(VUpdateMessageStatusEvent event);

  void onSeenAllMgs(VUpdateMessageSeenEvent event);

  void onDeliverAllMgs(VUpdateMessageDeliverEvent event);
}

mixin VRoomStream {
  late final StreamSubscription<VRoomEvents> _roomStream;

  void onInsertRoom(VInsertRoomEvent event);

  void onBlockSingleRoom(VBlockSingleRoomEvent event);

  void onUpdateOnline(VUpdateRoomOnlineEvent event);

  void onUpdateTyping(VUpdateRoomTypingEvent event);

  void onUpdateRoomName(VUpdateRoomNameEvent event);

  void onUpdateRoomImage(VUpdateRoomImageEvent event);

  void onAddOneToUnRead(VUpdateRoomUnReadCountByOneEvent event);

  void onResetRoomCounter(VUpdateRoomUnReadCountToZeroEvent event);

  void onChangeMute(VUpdateRoomMuteEvent event);

  void onDeleteRoom(VDeleteRoomEvent event);

  void initRoomStream(Stream<VRoomEvents> stream) {
    _roomStream = stream.listen(
      (event) {
        if (event is VInsertRoomEvent) {
          return onInsertRoom(event);
        }
        if (event is VBlockSingleRoomEvent) {
          return onBlockSingleRoom(event);
        }
        if (event is VUpdateRoomOnlineEvent) {
          return onUpdateOnline(event);
        }
        if (event is VUpdateRoomTypingEvent) {
          return onUpdateTyping(event);
        }
        if (event is VUpdateRoomNameEvent) {
          return onUpdateRoomName(event);
        }
        if (event is VUpdateRoomImageEvent) {
          return onUpdateRoomImage(event);
        }
        if (event is VUpdateRoomUnReadCountByOneEvent) {
          return onAddOneToUnRead(event);
        }
        if (event is VUpdateRoomUnReadCountToZeroEvent) {
          return onResetRoomCounter(event);
        }
        if (event is VUpdateRoomMuteEvent) {
          return onChangeMute(event);
        }
        if (event is VDeleteRoomEvent) {
          return onDeleteRoom(event);
        }
      },
    );
  }

  void closeRoomStream() {
    _roomStream.cancel();
  }
}
