import '../../v_chat_sdk_core.dart';

class VNativeApi {
  final local = LocalNativeApi();
  final remote = RemoteNativeApi();

  VNativeApi._();

  bool _isControllerInit = false;

  static final _instance = VNativeApi._();

  VNativeApi get I {
    assert(
      !_instance._isControllerInit,
      'This controller is already initialized',
    );
    return _instance;
  }

  static init() async {
    _instance._isControllerInit = true;
    await _instance.local.init();
  }
}

class LocalNativeApi {
  Future init() async {}
}

class RemoteNativeApi {
  final remoteSocketIo = RemoteSocketIo();
  final remoteRoom = RemoteRoom();
  final remoteAuth = RemoteAuth(
    VChatAuthApiService.init(),
  );
  final remoteMessage = RemoteMessage();
}

class RemoteSocketIo {}

class RemoteRoom {}

class RemoteMessage {}

class RemoteAuth {
  final VChatAuthApiService _authApiService;

  RemoteAuth(this._authApiService);

  Future<VIdentifierUser> login(VChatLoginDto dto) {
    return Future.value(_authApiService.login(dto));
  }

  Future<VIdentifierUser> register(VChatRegisterDto dto) {
    return Future.value(_authApiService.register(dto));
  }

  Future<bool> logout() {
    return Future.value(_authApiService.logout());
  }
}
