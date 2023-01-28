import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VPush {
  final bool enableVForegroundNotification;
  final VLocalNotificationPushConfig vPushConfig;
  final VChatPushProviderBase? fcmProvider;
  final VChatPushProviderBase? oneSignalProvider;

  VPush({
    required this.enableVForegroundNotification,
    required this.vPushConfig,
    this.fcmProvider,
    this.oneSignalProvider,
  });
}
