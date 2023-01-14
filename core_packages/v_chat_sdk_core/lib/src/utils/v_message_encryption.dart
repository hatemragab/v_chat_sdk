import 'package:v_chat_sdk_core/src/v_chat_controller.dart';

//todo encrypt the message
abstract class VMessageEncryption {
  final _key = VChatController.I.vChatConfig.encryptHashKey;

  static String encryptMessage(String message) {
    return message;
  }

  static String deCryptMessage(String message) {
    return message;
  }
}
