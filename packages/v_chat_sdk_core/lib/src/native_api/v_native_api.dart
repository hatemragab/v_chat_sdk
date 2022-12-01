import '../local_db/local_storage_service.dart';
import 'native_auth_api.dart';
import 'native_socket.dart';

class VNativeApi with SocketMixin, NativeAuthApi {
  final localStorage = LocalStorageService.instance;
}
