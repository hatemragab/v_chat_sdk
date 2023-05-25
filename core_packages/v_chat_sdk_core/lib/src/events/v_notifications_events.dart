// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show VBaseMessage, VRoom;

import '../models/v_app_event.dart';

class VOnNotificationsClickedEvent extends VAppEvent {
  final VBaseMessage message;
  final VRoom room;

  const VOnNotificationsClickedEvent({
    required this.message,
    required this.room,
  });

  @override
  List<Object?> get props => [message];
}

class VOnNewNotifications extends VAppEvent {
  final VBaseMessage message;
  final VRoom? room;
  const VOnNewNotifications({required this.message, this.room});

  @override
  List<Object?> get props => [];
}

class VOnUpdateNotificationsToken extends VAppEvent {
  final String token;

  const VOnUpdateNotificationsToken(this.token);

  @override
  List<Object?> get props => [token];
}
