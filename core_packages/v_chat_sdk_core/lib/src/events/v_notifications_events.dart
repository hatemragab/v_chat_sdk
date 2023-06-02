// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/v_app_event.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show VBaseMessage, VRoom;

/// Event triggered when a notification is clicked.
/// Contains the message and room associated with the clicked notification.
class VOnNotificationsClickedEvent extends VAppEvent {
  final VBaseMessage message; // The message from the clicked notification.
  final VRoom room; // The room associated with the clicked notification.

  const VOnNotificationsClickedEvent({
    required this.message,
    required this.room,
  });

  @override
  List<Object?> get props => [message];
}

/// Event triggered when a new notification is received.
/// Contains the message from the new notification and optionally the associated room.
class VOnNewNotifications extends VAppEvent {
  final VBaseMessage message; // The message from the new notification.
  final VRoom? room; // The room associated with the new notification. Optional.

  const VOnNewNotifications({required this.message, this.room});

  @override
  List<Object?> get props => [];
}

/// Event triggered when the notifications token is updated.
/// Contains the new notifications token.
class VOnUpdateNotificationsToken extends VAppEvent {
  final String token; // The updated notifications token.

  const VOnUpdateNotificationsToken(this.token);

  @override
  List<Object?> get props => [token];
}
