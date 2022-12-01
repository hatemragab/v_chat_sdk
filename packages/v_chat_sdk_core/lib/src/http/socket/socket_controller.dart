import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/utils/app_pref.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';

import '../../events/socket_status_event.dart';
import '../../utils/event_bus.dart';

class SocketController implements ISocketIoClient {
  SocketController._() {
    socketIoClient.socket.onConnect(
      (data) {
        log.finer("Socket connected !!");
        vChatEvents.fire(const VSocketStatusEvent(true));
      },
    );
    socketIoClient.socket.onDisconnect((data) {
      vChatEvents.fire(const VSocketStatusEvent(false));
    });
  }

  static final SocketController instance = SocketController._();

  bool get isSocketConnected => socketIoClient.socket.connected;
  final log = Logger('SocketController');
  final socketIoClient = SocketIoClient();
  final vChatEvents = EventBusSingleton.instance.vChatEvents;

  @override
  void connect() {
    final access = AppPref.getHashedString(key: StorageKeys.accessToken) ?? "";
    if (access.isNotEmpty) {
      socketIoClient.socket.io.options = {
        ...socketIoClient.socket.io.options,
        "query": "auth=Bearer%20$access",
        "extraHeaders": {
          ...socketIoClient.socket.io.options['extraHeaders']
              as Map<String, dynamic>,
          "Authorization": "Bearer $access"
        }
      };
      if (!isSocketConnected) {
        socketIoClient.connect();
      } else {
        log.warning(
          "you try to connect but you already connected ! i will disconnect and connect this will throw in future!",
        );
        socketIoClient.disconnect();
        connect();
      }
    }
  }

  @override
  Socket get currentSocket => socketIoClient.currentSocket;

  @override
  void destroy() => socketIoClient.destroy();

  @override
  void disconnect() => socketIoClient.disconnect();
}
