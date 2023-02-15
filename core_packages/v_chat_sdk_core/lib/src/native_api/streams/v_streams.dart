// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VStreams {
  final _emitter = VEventBusSingleton.vEventBus;

  Stream<VMessageEvents> get messageStream => _emitter.on<VMessageEvents>();

  Stream<VSocketStatusEvent> get socketStatusStream =>
      _emitter.on<VSocketStatusEvent>();

  Stream<VTotalUnReadCount> get totalUnreadMessageCountStream =>
      _emitter.on<VTotalUnReadCount>();

  Stream<VSocketIntervalEvent> get socketIntervalStream =>
      _emitter.on<VSocketIntervalEvent>();

  Stream<VRoomEvents> get roomStream => _emitter.on<VRoomEvents>();
  Stream<VCallEvents> get callStream => _emitter.on<VCallEvents>();

  Stream<VOnNotificationsClickedEvent> get vOnNotificationsClickedStream =>
      _emitter.on<VOnNotificationsClickedEvent>();

  Stream<VOnNewNotifications> get vOnNewNotificationStream =>
      _emitter.on<VOnNewNotifications>();

  Stream<VOnUpdateNotificationsToken> get vOnUpdateNotificationsTokenStream =>
      _emitter.on<VOnUpdateNotificationsToken>();
}
