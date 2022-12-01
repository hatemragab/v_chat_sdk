import 'package:socket_io_client/socket_io_client.dart';

import '../../v_chat_sdk_core.dart';
import '../http/socket/socket_controller.dart';
import '../utils/event_bus.dart';

mixin SocketMixin {
  final _vChatEvents = EventBusSingleton.instance.vChatEvents;

  Stream<VSocketStatusEvent> get socketStatusStream =>
      _vChatEvents.on<VSocketStatusEvent>();

  Stream<VMessageEvents> get messageStream => _vChatEvents.on<VMessageEvents>();

  Stream<VRoomEvents> get roomStream => _vChatEvents.on<VRoomEvents>();

  Stream<VSocketIntervalEvent> get socketIntervalStream =>
      _vChatEvents.on<VSocketIntervalEvent>();

  Socket get socket => SocketController.instance.currentSocket;
}
