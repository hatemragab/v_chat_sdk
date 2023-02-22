// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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

  void onNewMsg(VInsertMessageEvent event) {}

  void onUpdateMsg(VUpdateMessageEvent event) {}

  void onDeleteMsg(VDeleteMessageEvent event) {}

  void onUpdateMsgType(VUpdateMessageTypeEvent event) {}

  void onUpdateMsgStatus(VUpdateMessageStatusEvent event) {}

  void onSeenAllMgs(VUpdateMessageSeenEvent event) {}

  void onDeliverAllMgs(VUpdateMessageDeliverEvent event) {}
}

mixin VRoomStream {
  late final StreamSubscription<VRoomEvents> _roomStream;

  void onInsertRoom(VInsertRoomEvent event) {}

  void onGroupKicked(VOnGroupKicked event) {}

  void onBlockRoom(VBlockRoomEvent event) {}

  void onRoomOnline(VRoomOnlineEvent event) {}

  void onRoomOffline(VRoomOfflineEvent event) {}

  void onUpdateTyping(VUpdateRoomTypingEvent event) {}

  void onUpdateRoomName(VUpdateRoomNameEvent event) {}

  void onUpdateRoomImage(VUpdateRoomImageEvent event) {}

  void onAddOneToUnRead(VUpdateRoomUnReadCountByOneEvent event) {}

  void onResetRoomCounter(VUpdateRoomUnReadCountToZeroEvent event) {}

  void onChangeMute(VUpdateRoomMuteEvent event) {}

  void onDeleteRoom(VDeleteRoomEvent event) {}

  void initRoomStream(Stream<VRoomEvents> stream) {
    _roomStream = stream.listen(
      (event) {
        if (event is VInsertRoomEvent) {
          return onInsertRoom(event);
        }
        if (event is VBlockRoomEvent) {
          return onBlockRoom(event);
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
        if (event is VRoomOfflineEvent) {
          return onRoomOffline(event);
        }
        if (event is VRoomOnlineEvent) {
          return onRoomOnline(event);
        }
        if (event is VOnGroupKicked) {
          return onGroupKicked(event);
        }
      },
    );
  }

  void closeRoomStream() {
    _roomStream.cancel();
  }
}

mixin VVAppLifeCycleStream {
  StreamSubscription<VAppLifeCycle>? _vAppLifeCycleStream;

  void initVAppLifeCycleStreamStream() {
    _vAppLifeCycleStream =
        VEventBusSingleton.vEventBus.on<VAppLifeCycle>().listen((event) {
      if (event.isGoBackground) {
        onGoToBackground();
      } else {
        onGoToFront();
      }
    });
  }

  void closeVAppLifeCycleStreamStream() {
    _vAppLifeCycleStream?.cancel();
  }

  void onGoToBackground() {}

  void onGoToFront() {}
}

mixin VSocketStatusStream {
  StreamSubscription<VSocketStatusEvent>? _socketStatusStream;

  void initSocketStatusStream(Stream<VSocketStatusEvent> stream) {
    _socketStatusStream = stream.listen((event) {
      if (event.isConnected) {
        onSocketConnected();
      } else {
        onSocketDisconnect();
      }
    });
  }

  void closeSocketStatusStream() {
    _socketStatusStream?.cancel();
  }

  void onSocketConnected() {}

  void onSocketDisconnect() {}
}

mixin VSocketIntervalStream {
  late final StreamSubscription<VSocketIntervalEvent>
      _socketIntervalStatusStream;

  void initSocketIntervalStream(Stream<VSocketIntervalEvent> stream) {
    _socketIntervalStatusStream = stream.listen((event) {
      onIntervalFire();
    });
  }

  void closeSocketIntervalStream() {
    _socketIntervalStatusStream.cancel();
  }

  void onIntervalFire();
}
