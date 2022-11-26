import 'package:v_chat_sdk_core/src/http/dto/dto.dart';
import 'package:v_chat_sdk_core/src/types/types.dart';

import 'http/abstraction/auth_abs.dart';

class VChatController implements AuthEndPoints {
  VChatController._privateConstructor();

  static final VChatController instance = VChatController._privateConstructor();
  VChatPushProviderBase? pushProvider;

  Future<void> init({VChatPushProviderBase? pushProvider}) async {
    this.pushProvider = pushProvider;
  }

  @override
  Future<String> login(VChatLoginDto dto) async {
    if (pushProvider == null) return "pushProvider ==null";
    return pushProvider!.getToken().toString();
  }

  @override
  Future<String> register(VChatRegisterDto dto) async {
    if (pushProvider == null) return "pushProvider ==null";
    return pushProvider!.getToken().toString();
  }
}
