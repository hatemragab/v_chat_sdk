import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class NativeRemoteSocketIo {
  Socket get socket => SocketController.instance.currentSocket;

  bool get isConnected => SocketController.instance.currentSocket.connected;

  void emitGetMyOnline(List<VOnlineOfflineModel> ids) =>
      SocketController.instance.emitGetMyOnline(jsonEncode(
        ids.map((e) => e.toMap()).toList(),
      ),);

  void emitUpdateRoomStatus(VSocketRoomTypingModel model) =>
      SocketController.instance.emitUpdateRoomStatus(jsonEncode(model.toMap()));

  void emitDeliverRoomMessages(String roomId) => SocketController.instance
      .emitDeliverRoomMessages(jsonEncode({"roomId": roomId}));

  void emitSeenRoomMessages(String roomId) => SocketController.instance
      .emitSeenRoomMessages(jsonEncode({"roomId": roomId}));
}
