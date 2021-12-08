import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';

import '../../../models/v_chat_message.dart';
import '../../../services/local_storage_service.dart';
import '../../../services/v_chat_app_service.dart';
import '../../../utils/api_utils/server_config.dart';

class MessageSocket {
  late Socket _socket;
  final String currentRoomId;
  final localStorageService = LocalStorageService.instance;
  final String myId;
  final Function(VChatMessage message) onNewMessage;
  final Function(List<VChatMessage> messages) onAllMessages;

  MessageSocket({
    required this.currentRoomId,
    required this.myId,
    required this.onNewMessage,
    required this.onAllMessages,
  }) {
    connectMessageSocket();
  }

  void connectMessageSocket() async {

    await Future.delayed(const Duration(milliseconds: 200));
    _socket = _getSocket();
    _socket.onConnect((data) async {
      _socket.on("all_messages", (data) async {
        final msgList = (jsonDecode(data)) as List;
        final x = msgList.map((e) => VChatMessage.fromMap(e)).toList();
        unawaited(
            localStorageService.setRoomMessages(currentRoomId.toString(), x));
        onAllMessages(x);
      });
      _socket.on('new_message', (data) async {
        final msgMap = jsonDecode(data);
        final message = VChatMessage.fromMap(msgMap);
        unawaited(localStorageService.insertMessage(
            currentRoomId.toString(), message));
        onNewMessage(message);
      });
      _socket.onReconnecting((data) {
        offAllListeners();
        cache.clear();
      });
      await Future.delayed(const Duration(milliseconds: 100));
      _socket.emit("join", currentRoomId.toString());
    });
  }

  Socket _getSocket() {
    return io("${ServerConfig.serverIp}/message", <String, dynamic>{
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

  void offAllListeners() {
    _socket.off("new_message");
    _socket.off("all_messages");
  }

  void dispose() {
    _socket.disconnect();
    _socket.dispose();
  }

  void disconnect() {
    _socket.disconnect();
  }
}
