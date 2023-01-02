import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../http/socket/socket_controller.dart';

class NativeRemoteSocketIo {
  final _vChatEvents = VEventBusSingleton.vEventBus;

  Socket get socket => SocketController.instance.currentSocket;

  bool get isConnected => SocketController.instance.currentSocket.connected;

  Stream<VSocketStatusEvent> get socketStatusStream =>
      _vChatEvents.on<VSocketStatusEvent>();

  Stream<VSocketIntervalEvent> get socketIntervalStream =>
      _vChatEvents.on<VSocketIntervalEvent>();

  void emitGetMyOnline(List<VOnlineOfflineModel> ids) =>
      SocketController.instance.emitGetMyOnline(jsonEncode(
        ids.map((e) => e.toMap()).toList(),
      ));

  void emitUpdateRoomStatus(VSocketRoomTypingModel model) =>
      SocketController.instance.emitUpdateRoomStatus(jsonEncode(model.toMap()));

  void emitDeliverRoomMessages(String roomId) => SocketController.instance
      .emitDeliverRoomMessages(jsonEncode({"roomId": roomId}));

  void emitSeenRoomMessages(String roomId) => SocketController.instance
      .emitSeenRoomMessages(jsonEncode({"roomId": roomId}));
}
