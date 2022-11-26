abstract class VChatPushProviderBase {
  Future<bool> init();

  Future<String?> getToken();

  Future<void> deleteToken();
}
