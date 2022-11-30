import 'package:socket_io_client/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/src/utils/app_pref.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';

abstract class ISocketIoClient {
  void connect();

  void disconnect();

  void destroy();

  Socket get currentSocket;
}

class SocketIoClient implements ISocketIoClient {
  factory SocketIoClient() {
    return _singleton;
  }

  SocketIoClient._internal(this.socket);

  final Socket socket;

  static final _singleton = SocketIoClient._internal(_getSocket());

  static Socket _getSocket() {
    final accessString =
        AppPref.getHashedString(key: StorageKeys.accessToken) ?? '';
    // print(accessString);
    // if (accessString.isEmpty) {
    //   throw Exception("_getSocket while AppAuth.myAccessToken is Empty !");
    // }
    final access = "Bearer $accessString";
    return io(
      ApiConstants.baseServerIp,
      OptionBuilder()
          .setQuery({
            "auth": access,
          })
          .setExtraHeaders({
            'Authorization': access,
            "clint-version": ApiConstants.clintVersion,
          })
          .setTransports(['websocket'])
          .enableForceNew()
          .disableAutoConnect()
          .enableForceNewConnection()
          .enableReconnection()
          .setTimeout(5000)
          .setReconnectionDelay(5000)
          .build(),
    );
  }

  @override
  void connect() {
    socket.connect();
  }

  @override
  void disconnect() {
    socket.disconnect();
  }

  @override
  void destroy() {
    socket.destroy();
  }

  @override
  Socket get currentSocket => socket;
}
