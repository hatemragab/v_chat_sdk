import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk/src/modules/rooms/cubit/room_cubit.dart';

import '../enums/socket_state_type.dart';
import '../models/v_chat_room.dart';
import '../models/v_chat_room_typing.dart';
import '../utils/custom_widgets/custom_alert_dialog.dart';
import '../utils/v_chat_config.dart';
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
    return io(VChatConfig.serverIp, <String, dynamic>{
      'transports': ['websocket'],
      'pingTimeout': 5000,
      'connectTimeout': 5000,
      'pingInterval': 5000,
      'extraHeaders': <String, String>{
        'Authorization': VChatAppService.instance.vChatUser!.accessToken,
        "accept-language": VChatAppService.instance.currentLocal
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
    offAllListeners();
    _socket!.disconnect();
    _socket = null;
    //_socket.destroy();
  }

  Future<void> initSockedEvents() async {
    _socket!.on("all_rooms", (data)  {
      final _roomsMaps = data as List;
      final _rooms = _roomsMaps.map((e) => VChatRoom.fromMap(e)).toList();
      RoomCubit.instance.setSocketRooms(_rooms);
      unawaited(LocalStorageService.instance.setRooms(_rooms));
    });

    _socket!.on("update_one_room", (_room) {
      final room = VChatRoom.fromMap(_room);
      unawaited(LocalStorageService.instance.setRoomOrUpdate(room));
      RoomCubit.instance.updateOneRoomInRamAndSort(room);
    });

    _socket!.on("user_online_changed", (data) {
      final res = jsonDecode(data as String);
      final status = res['status'] as int;
      final roomId = res['roomId'] as String;
      RoomCubit.instance.updateRoomOnlineChanged(status, roomId);
    });
    _socket!.on("kick_from_group", (roomId ) {
      if(RoomCubit.instance.isRoomOpen(roomId as String)){
        RoomCubit.instance.pop();
      }
    });

    _socket!.on("user_typing_changed", (data) {
      RoomCubit.instance.updateRoomTypingChanged(
        VChatRoomTyping.fromMap(data as Map<String, dynamic>),
      );
    });

    _socket!.emitWithAck(
      "join",
      "join",
      ack: (data) {
        final _roomsMaps = data['data'] as List;
        final _rooms = _roomsMaps.map((e) => VChatRoom.fromMap(e)).toList();
        RoomCubit.instance.setSocketRooms(_rooms);
        unawaited(LocalStorageService.instance.setRooms(_rooms));
      },
    );
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
