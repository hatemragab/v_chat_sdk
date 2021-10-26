import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../enums/socket_state_type.dart';
import '../models/v_chat_room.dart';
import '../models/v_chat_room_typing.dart';
import '../utils/api_utils/server_config.dart';
import '../utils/custom_widgets/custom_alert_dialog.dart';
import 'socket_controller.dart';
import 'v_chat_app_service.dart';

class SocketService extends GetxController {
  final VChatAppService _appService = VChatAppService.to;
  final SocketController _socketController = Get.find<SocketController>();

  late Socket _socket;
  final socketState = SocketStateType.connecting.obs;

  bool get isConnected => _socket.connected;

  Socket getSocket() {
    return io(ServerConfig.serverIp, <String, dynamic>{
      'transports': ['websocket'],
      'pingTimeout': 5000,
      'connectTimeout': 5000,
      'pingInterval': 5000,
      'extraHeaders': <String, String>{
        'Authorization': _appService.vChatUser!.accessToken
      },
      'forceNew': true
    });
  }

  @override
  void onClose() {
    _socket.disconnect();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    connectSocket();
  }

  void emitRefreshChats() {
    _socket.emit("join");
  }

  void connectSocket() {
    bool isErrorAlertShown = false;
    _socket = getSocket();
    _socket.onConnect((data) {
      socketState.value = SocketStateType.connected;
      // _log.debug("socket connected successful");
      initSockedEvents();
    });
    _socket.onDisconnect((data) {
      socketState.value = SocketStateType.connecting;
      //  _log.debug("socket disconnected because $data");
    });
    _socket.onReconnecting((data) {
      offAllListeners();
      cache.clear();
    });

    _socket.onError((data) {
      if (data.toString() == "{message: auth must be provided ! $data}" &&
          !isErrorAlertShown) {
        isErrorAlertShown = true;
        CustomAlert.error(msg: data.toString());
      }
    });
  }

  void initSockedEvents() async {
    _socket.on("all_rooms", (data) {
      final _rooms = jsonDecode(data) as List;
      _socketController.handleOnAllRoomsEvent(
          _rooms.map((e) => VChatRoom.fromMap(e)).toList());
    });

    _socket.on("update_one_room", (data) {
      final _room = jsonDecode(data);
      _socketController.handleOnUpdateOneRoomEvent(VChatRoom.fromMap(_room));
    });

    _socket.on("user_online_changed", (data) {
      final res = jsonDecode(data);
      final status = res['status'];
      final roomId = res['roomId'];
      _socketController.handleRoomOnlineChanged(status, roomId);
    });

    _socket.on("user_typing_changed", (data) {
      _socketController.handleRoomTypingChanged(VChatRoomTyping.fromMap(data));
    });

    await Future.delayed(const Duration(milliseconds: 100));
    _socket.emit("join");
  }

  void offAllListeners() {
    _socket.off("all_rooms");
    _socket.off("update_one_room");
    _socket.off("user_typing_changed");
    _socket.off("user_online_changed");
  }



  void emitTypingChange(Map<String, dynamic> data) {
    _socket.emit("typing_changed", data);
  }
}
