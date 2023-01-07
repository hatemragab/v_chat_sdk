import '../../../v_chat_sdk_core.dart';

class NativeRemoteAuth {
  final AuthApiService _authApiService;

  NativeRemoteAuth(this._authApiService);

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