// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class OfflineOnlineEmitterService {
  final _emitter = VEventBusSingleton.vEventBus;

  void start() {
    _emitter.on<VOnlineOfflineModel>().listen((e) {
      if (e.isOnline) {
        _handleOnlineEvent(e);
      } else {
        _handleOfflineEvent(e);
      }
    });
  }

  void _handleOnlineEvent(VOnlineOfflineModel e) {
    // final isOnline = OnlineOfflineService.isUserOnlineByPeerId(e.peerId);
    //if (isOnline) return;
    // OnlineOfflineService.setUser(e);
    _emitter.fire(VRoomOnlineEvent(roomId: e.roomId));
  }

  void _handleOfflineEvent(VOnlineOfflineModel e) {
    //we need to set this user offline
    // final isOffline = OnlineOfflineService.isUserOfflineByPeerId(e.peerId);
    // if (isOffline) return;
    // OnlineOfflineService.setUser(e);
    _emitter.fire(VRoomOfflineEvent(roomId: e.roomId));
  }
}
