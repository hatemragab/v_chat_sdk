// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class NativeRemoteSocketIo {
  Socket get socket => SocketController.instance.currentSocket;

  Completer<void> get socketCompleter =>
      SocketController.instance.socketCompleter;

  bool get isConnected => SocketController.instance.currentSocket.connected;

  void emitGetMyOnline(List<Map<String, dynamic>> ids) =>
      SocketController.instance.emitGetMyOnline(
        jsonEncode(ids),
      );

  void emitUpdateRoomStatus(VSocketRoomTypingModel model) =>
      SocketController.instance.emitUpdateRoomStatus(jsonEncode(model.toMap()));

  void emitDeliverRoomMessages(String roomId) => SocketController.instance
      .emitDeliverRoomMessages(jsonEncode({"roomId": roomId}));

  void emitRtcIce(
    Map<String, dynamic> data,
    String meetId,
  ) =>
      SocketController.instance.emitRtcIce(
        jsonEncode(
          {"data": data, "meetId": meetId},
        ),
      );

  void emitSeenRoomMessages(String roomId) => SocketController.instance
      .emitSeenRoomMessages(jsonEncode({"roomId": roomId}));
}
