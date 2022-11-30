import '../../v_chat_sdk_core.dart';

abstract class VChatPushProviderBase {
  Future<bool> init();

  Future<String?> getToken();

  Future<void> deleteToken();

  VChatPushService serviceName();
}
