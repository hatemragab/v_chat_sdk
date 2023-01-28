import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class VChatPushProviderBase {
  const VChatPushProviderBase();

  Future<bool> init();

  Future<String?> getToken();

  Future<void> deleteToken();

  Future<void> cleanAll({
    int? notificationId,
  });

  Future<void> askForPermissions();

  Future<VBaseMessage?> getOpenAppNotification();

  void close();

  VChatPushService serviceName();
}
