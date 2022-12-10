import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';

import '../../../v_chat_sdk_core.dart';
import '../../http/socket/socket_controller.dart';
import '../../models/socket/room_typing_model.dart';
import '../../utils/event_bus.dart';

class NativeRemoteSocketIo {
  final _vChatEvents = EventBusSingleton.instance.vChatEvents;

  Socket get socket => SocketController.instance.currentSocket;

  Stream<VSocketStatusEvent> get socketStatusStream =>
      _vChatEvents.on<VSocketStatusEvent>();

  Stream<VSocketIntervalEvent> get socketIntervalStream =>
      _vChatEvents.on<VSocketIntervalEvent>();

  void emitGetMyOnline(List<String> ids) =>
      SocketController.instance.emitGetMyOnline(jsonEncode(ids));

  void emitUpdateRoomStatus(RoomTypingModel model) =>
      SocketController.instance.emitUpdateRoomStatus(jsonEncode(model.toMap()));

  void emitDeliverRoomMessages(String roomId) => SocketController.instance
      .emitDeliverRoomMessages(jsonEncode({"roomId": roomId}));

  void emitSeenRoomMessages(String roomId) => SocketController.instance
      .emitSeenRoomMessages(jsonEncode({"roomId": roomId}));
}
