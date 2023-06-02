// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// This class provides methods for socket operations like connecting,
/// disconnecting and emitting various types of events.
class NativeRemoteSocketIo {
  /// Returns the current socket instance from the [SocketController].
  Socket get socket => SocketController.instance.currentSocket;

  /// Returns the socket completer from the [SocketController].
  Completer<void> get socketCompleter =>
      SocketController.instance.socketCompleter;

  /// Checks whether the socket is currently connected.
  bool get isConnected => SocketController.instance.currentSocket.connected;

  /// Emits an event to fetch the online status of the given ids.
  void emitGetMyOnline(List<Map<String, dynamic>> ids) =>
      SocketController.instance.emitGetMyOnline(
        jsonEncode(ids),
      );

  /// Emits an event to update the typing status of a room with the given [model].
  void emitUpdateRoomStatus(VSocketRoomTypingModel model) =>
      SocketController.instance.emitUpdateRoomStatus(jsonEncode(model.toMap()));

  /// Emits an event to mark all messages in a room as delivered.
  void emitDeliverRoomMessages(String roomId) => SocketController.instance
      .emitDeliverRoomMessages(jsonEncode({"roomId": roomId}));

  /// Emits an RTC Ice event with the given [data] and [meetId].
  void emitRtcIce(
    Map<String, dynamic> data,
    String meetId,
  ) =>
      SocketController.instance.emitRtcIce(
        jsonEncode(
          {"data": data, "meetId": meetId},
        ),
      );

  /// Emits an event to mark all messages in a room as seen.
  void emitSeenRoomMessages(String roomId) => SocketController.instance
      .emitSeenRoomMessages(jsonEncode({"roomId": roomId}));
}
