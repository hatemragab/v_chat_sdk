import 'package:v_chat_sdk_core/src/v_chat_controller.dart';

import 'events/socket_status_event.dart';
import 'events/v_message_events.dart';
import 'events/v_socket_interval.dart';

class VNativeApi {
  Stream<VSocketStatusEvent> get socketStatusStream =>
      vChatEvents.on<VSocketStatusEvent>();

  Stream<VMessageEvents> get messageStream => vChatEvents.on<VMessageEvents>();

  Stream<VSocketIntervalEvent> get socketIntervalStream =>
      vChatEvents.on<VSocketIntervalEvent>();
}
