import '../../v_chat_sdk_core.dart';

mixin NativeAuthApi {
  final _authApiService = VChatAuthApiService.instance;
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
