import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VStreams {
  final _emitter = VEventBusSingleton.vEventBus;

  Stream<VMessageEvents> get messageStream => _emitter.on<VMessageEvents>();

  Stream<VSocketStatusEvent> get socketStatusStream =>
      _emitter.on<VSocketStatusEvent>();

  Stream<VSocketIntervalEvent> get socketIntervalStream =>
      _emitter.on<VSocketIntervalEvent>();

  Stream<VRoomEvents> get roomStream => _emitter.on<VRoomEvents>();

  Stream<VOnNotificationsClickedEvent> get vOnNotificationsClickedStream =>
      _emitter.on<VOnNotificationsClickedEvent>();

  Stream<VOnNewNotifications> get vOnNewNotificationStream =>
      _emitter.on<VOnNewNotifications>();

  Stream<VOnUpdateNotificationsToken> get vOnUpdateNotificationsTokenStream =>
      _emitter.on<VOnUpdateNotificationsToken>();
}
