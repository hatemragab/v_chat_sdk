import '../../v_chat_utils.dart';

abstract class VChatPushProviderBase {
  Future<bool> init();

  Future<String?> getToken();

  Future<void> deleteToken();

  Future<void> askForPermissions();

  void close();

  VChatPushService serviceName();
}
