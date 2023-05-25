// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_service.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../events/event_bus.dart';

class SocketController implements ISocketIoClient {
  final _log = Logger('SocketController');
  late final SocketService _socketService;
  final Completer<void> socketCompleter = Completer<void>();

  Socket get _socket => socketIoClient.socket;
  static final SocketController instance = SocketController._();

  bool get isSocketConnected => socketIoClient.socket.connected;
  final socketIoClient = SocketIoClient();
  final vChatEvents = VEventBusSingleton.vEventBus;

  SocketController._() {
    _socketService = SocketService(socketIoClient);
    _initSocketEvents();
    socketIoClient.socket.onConnect(
      (data) {
        if (!socketCompleter.isCompleted) {
          socketCompleter.complete();
        }
        _log.finer("Socket connected successfully");
        vChatEvents.fire(const VSocketStatusEvent(isConnected: true));
      },
    );
    _socket.onError((data) {
      _log.warning("_socket.onError:$data");
      vChatEvents.fire(const VSocketStatusEvent(isConnected: false));
    });
    socketIoClient.socket.onDisconnect((data) {
      _log.finer("Socket onDisconnect successfully");
      vChatEvents.fire(const VSocketStatusEvent(isConnected: false));
    });
  }

  @override
  void connect() {
    _socketService.handleConnect();
  }

  @override
  Socket get currentSocket => socketIoClient.currentSocket;

  @override
  void destroy() => socketIoClient.destroy();

  @override
  void disconnect() => socketIoClient.disconnect();

  void _initSocketEvents() {
    final hasListeners = _socket.hasListeners(SocketEvents.v1OnNewMessage.name);
    if (hasListeners) {
      return;
    }
    _socket.on(SocketEvents.v1OnNewMessage.name, (dynamic msg) async {
      final message = MessageFactory.createBaseMessage(
        jsonDecode(msg.toString()) as Map<String, dynamic>,
      );
      await _socketService.handleOnNewMessage(message);
    });
    _socket.on(SocketEvents.v1OnMyOnline.name, (dynamic data) async {
      final dataMap = jsonDecode(data.toString()) as List;
      final dataModelList = dataMap
          .map((e) => VOnlineOfflineModel.fromMap(e as Map<String, dynamic>))
          .toList();
      _socketService.handleOnGetMyOnlineList(dataModelList);
    });
    _socket.on(SocketEvents.v1OnException.name, (dynamic data) async {
      _log.warning("SocketEvents.v1OnException:$data");
    });
    _socket.on(SocketEvents.v1OnEnterChatRoom.name, (dynamic data) async {
      final model = VSocketOnRoomSeenModel.fromMap(
        jsonDecode(data.toString()) as Map<String, dynamic>,
      );
      await Future.delayed(const Duration(milliseconds: 100));
      _socketService.handleOnEnterChatRoom(model);
    });
    _socket.on(SocketEvents.v1OnDeliverChatRoom.name, (dynamic data) async {
      final model = VSocketOnDeliverMessagesModel.fromMap(
        jsonDecode(data.toString()) as Map<String, dynamic>,
      );
      await Future.delayed(const Duration(milliseconds: 100));
      _socketService.handleOnDeliverRoomMessages(model);
    });
    _socket.on(SocketEvents.v1OnRoomStatusChange.name, (dynamic data) async {
      final x = VSocketRoomTypingModel.fromMap(
        jsonDecode(data.toString()) as Map<String, dynamic>,
      );
      await _socketService.handleOnRoomTypingChanged(x);
    });
    _socket.on(SocketEvents.v1OnBanUserChat.name, (dynamic json) async {
      final data = jsonDecode(json.toString()) as Map<String, dynamic>;
      final ban = VSingleBlockModel.fromMap(data);
      await _socketService.handleOnSingleRoomBan(ban);
    });

    _socket.on(SocketEvents.v1OnKickGroupMember.name, (dynamic json) async {
      final data = jsonDecode(json.toString()) as Map<String, dynamic>;
      await _socketService.handleOnGroupKick(data);
    });

    _socket.on(
      SocketEvents.v1OnDeleteMessageFromAll.name,
      (dynamic data) async {
        final msg = MessageFactory.createBaseMessage(
          jsonDecode(data.toString()) as Map<String, dynamic>,
        );
        await _socketService.updateMessageToAllDeleted(msg);
      },
    );

    _socket.on(
      SocketEvents.v1OnNewCall.name,
      (dynamic data) async {
        _socketService.handleNewCall(
          VNewCallModel.fromMap(
            jsonDecode(data.toString()) as Map<String, dynamic>,
          ),
        );
      },
    );

    _socket.on(
      SocketEvents.v1OnCallTimeout.name,
      (dynamic data) async {
        final res = jsonDecode(data.toString()) as Map<String, dynamic>;
        _socketService.handleCallTimeout(res['roomId'] as String);
      },
    );

    _socket.on(
      SocketEvents.v1OnCallCanceled.name,
      (dynamic data) async {
        final res = jsonDecode(data.toString()) as Map<String, dynamic>;
        _socketService.handleCallCanceled(res['roomId'] as String);
      },
    );
    _socket.on(
      SocketEvents.v1OnCallRejected.name,
      (dynamic data) async {
        final res = jsonDecode(data.toString()) as Map<String, dynamic>;
        _socketService.handleCallRejected(res['roomId'] as String);
      },
    );

    _socket.on(
      SocketEvents.v1OnIceCandidate.name,
      (dynamic data) async {
        final res = jsonDecode(data.toString()) as Map<String, dynamic>;
        _socketService.handleOnIce(res);
      },
    );
    _socket.on(
      SocketEvents.v1OnCallAccepted.name,
      (dynamic data) async {
        final res = jsonDecode(data.toString()) as Map<String, dynamic>;
        _socketService.handleCallAccepted(VOnAcceptCall.fromMap(res));
      },
    );
    _socket.on(
      SocketEvents.v1OnCallEnded.name,
      (dynamic data) async {
        final res = jsonDecode(data.toString()) as Map<String, dynamic>;
        _socketService.handleCallEnded(res['roomId'] as String);
      },
    );
  }

  void emitGetMyOnline(String data) {
    _socket.emit(
      SocketEvents.v1MyOnline.name,
      data,
    );
  }

  void emitUpdateRoomStatus(String data) {
    _socket.emit(
      SocketEvents.v1RoomStatusChange.name,
      data,
    );
  }

  void emitDeliverRoomMessages(String data) {
    _socket.emit(
      SocketEvents.v1DeliverChatRoom.name,
      data,
    );
  }

  void emitRtcIce(String data) {
    _socket.emit(
      SocketEvents.v1IceCandidate.name,
      data,
    );
  }

  void emitSeenRoomMessages(String data) {
    _socket.emit(
      SocketEvents.v1EnterChatRoom.name,
      data,
    );
  }
}

enum SocketEvents {
  ///Listeners
  v1OnNewMessage,
  v1OnRoomById,
  v1OnMyOnline,
  v1OnException,
  v1OnEnterChatRoom,
  v1OnDeliverChatRoom,
  v1OnRoomStatusChange,
  v1OnBanUserChat,
  v1OnKickGroupMember,
  v1OnDeleteMessageFromAll,

  //call events
  v1OnCallAccepted,
  v1OnCallEnded,
  v1OnNewCall,
  v1OnCallTimeout,
  v1OnCallCanceled,
  v1OnCallRejected,
  v1OnIceCandidate,

  ///Emitter
  v1RoomStatusChange,
  v1MyOnline,
  v1EnterChatRoom,
  v1DeliverChatRoom,
  v1IceCandidate
}
