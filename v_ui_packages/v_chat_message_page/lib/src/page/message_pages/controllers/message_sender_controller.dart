import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageSenderController {
  final _vConfig = VChatController.I.vChatConfig;

  ///singleton
  MessageSenderController._();

  static final _instance = MessageSenderController._();

  static MessageSenderController get I {
    return _instance;
  }

  void onSubmitText(String message) {
    // final isEnable = _vConfig.enableEndToEndMessageEncryption;
    // final localMsg = VTextMessage.buildMessage(
    //   content: isEnable ? VMessageEncryption.encryptMessage(message) : message,
    //   isEncrypted: isEnable,
    //   roomId: vRoom.id,
    // );
  }
}
