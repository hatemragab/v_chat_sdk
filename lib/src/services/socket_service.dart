import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk/src/modules/rooms/cubit/room_cubit.dart';
import '../enums/socket_state_type.dart';
import '../models/v_chat_room.dart';
import '../models/v_chat_room_typing.dart';
import '../utils/api_utils/server_config.dart';
import '../utils/custom_widgets/custom_alert_dialog.dart';
import 'local_storage_service.dart';
import 'v_chat_app_service.dart';

class SocketService {
  ValueNotifier<SocketStateType> socketStateValue =
      ValueNotifier(SocketStateType.connecting);

  SocketService() {
    connectSocket();
  }

  Socket? _socket;

  bool get isConnected => _socket!.connected;

  Socket getSocket() {
    return io(ServerConfig.serverIp, <String, dynamic>{
      'transports': ['websocket'],
      'pingTimeout': 5000,
      'connectTimeout': 5000,
      'pingInterval': 5000,
      'extraHeaders': <String, String>{
        'Authorization': VChatAppService.instance.vChatUser!.accessToken
      },
      'forceNew': true
    });
  }

  void emitRefreshChats() {
    _socket!.emit("join");
  }

  void connectSocket() {
    bool isErrorAlertShown = false;
    _socket = getSocket();
    _socket!.onConnect((data) {
      socketStateValue.value = SocketStateType.connected;
      // _log.debug("socket connected successful");
      initSockedEvents();
    });
    _socket!.onDisconnect((data) {
      socketStateValue.value = SocketStateType.connecting;
      //  _log.debug("socket disconnected because $data");
    });
    _socket!.onReconnecting((data) {
      offAllListeners();
      cache.clear();
    });

    _socket!.onError((data) {
      if (data.toString() == "{message: auth must be provided ! $data}" &&
          !isErrorAlertShown) {
        isErrorAlertShown = true;
        CustomAlert.error(msg: data.toString());
      }
    });
  }

  void destroy() {
    print("Start destroy Chat socket ");
    offAllListeners();
    _socket!.disconnect();
    _socket = null;
    //_socket.destroy();
  }

  void initSockedEvents() async {
    // _socket!.on("all_rooms", (data) {
    //   final _roomsMaps = jsonDecode(data) as List;
    //   final _rooms = _roomsMaps.map((e) => VChatRoom.fromMap(e)).toList();
    //   RoomCubit.instance.setSocketRooms(_rooms);
    //   unawaited(LocalStorageService.instance.setRooms(_rooms));
    // });

    _socket!.on("update_one_room", (_room) {
      //   print(data.toString());
      // final _room = jsonDecode(data);
      final room = VChatRoom.fromMap(_room);
      unawaited(LocalStorageService.instance.setRoomOrUpdate(room));
      RoomCubit.instance.updateOneRoomInRamAndSort(room);
    });

    _socket!.on("user_online_changed", (data) {
      final res = jsonDecode(data);
      final status = res['status'];
      final roomId = res['roomId'];
      RoomCubit.instance.updateRoomOnlineChanged(status, roomId);
    });

    _socket!.on("user_typing_changed", (data) {
      RoomCubit.instance.updateRoomTypingChanged(VChatRoomTyping.fromMap(data));
    });

    _socket!.emitWithAck("join", "join", ack: (data) {
      final _roomsMaps = data['data'] as List;
      final _rooms = _roomsMaps.map((e) => VChatRoom.fromMap(e)).toList();
      RoomCubit.instance.setSocketRooms(_rooms);
      unawaited(LocalStorageService.instance.setRooms(_rooms));
    });
  }

  void offAllListeners() {
    _socket!.off("all_rooms");
    _socket!.off("update_one_room");
    _socket!.off("user_typing_changed");
    _socket!.off("user_online_changed");
  }

  void emitTypingChange(Map<String, dynamic> data) {
    _socket!.emit("typing_changed", data);
  }
}
