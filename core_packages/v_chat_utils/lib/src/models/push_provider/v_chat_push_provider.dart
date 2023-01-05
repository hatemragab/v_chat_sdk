import '../../../v_chat_utils.dart';

abstract class VChatPushProviderBase {
  final bool enableForegroundNotification;
  final VPushConfig vPushConfig;

  const VChatPushProviderBase({
    this.enableForegroundNotification = true,
    required this.vPushConfig,
  });

  Future<bool> init();

  Future<String?> getToken();

  Future<void> deleteToken();

  Future<void> askForPermissions();

  Future<Map<String, dynamic>?> getOpenAppNotification();

  void close();

  VChatPushService serviceName();

  Stream<VNotificationModel> eventsStream();
}
