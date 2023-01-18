import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_service.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class SocketController implements ISocketIoClient {
  final _log = Logger('SocketController');
  late final SocketService _socketService;
  final Completer<void> socketCompleter = Completer<void>();
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
      vChatEvents.fire(const VSocketStatusEvent(isConnected: false));
    });
  }

  Socket get _socket => socketIoClient.socket;

  static final SocketController instance = SocketController._();

  bool get isSocketConnected => socketIoClient.socket.connected;
  final socketIoClient = SocketIoClient();
  final vChatEvents = VEventBusSingleton.vEventBus;

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
      final ban = OnBanUserChatModel.fromMap(data);
      await _socketService.handleOnRoomBan(ban);
    });

    _socket.on(
      SocketEvents.v1OnDeleteMessageFromAll.name,
      (dynamic data) async {
        final msg = MessageFactory.createBaseMessage(
          jsonDecode(data.toString()) as Map<String, dynamic>,
        );
        await _socketService.updateMessageType(msg);
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

  ///Emitter
  v1RoomStatusChange,
  v1MyOnline,
  v1EnterChatRoom,
  v1DeliverChatRoom,
}
