import 'package:v_chat_sdk_core/src/http/dto/dto.dart';

abstract class AuthEndPoints {
  Future<String> login(VChatLoginDto dto);

  Future<String> register(VChatRegisterDto dto);
}
