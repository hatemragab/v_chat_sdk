import 'package:flutter/foundation.dart';

import 'package:v_chat_sdk_core/src/models/push_provider/v_chat_push_provider.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChatConfig {
  final VChatPushProviderBase? fcmPushProvider;
  final VChatPushProviderBase? oneSignalPushProvider;
  final bool enableLog;
  final bool enableMessageEncryption;

  final int maxGroupMembers;
  final int maxBroadcastMembers;
  final String encryptHashKey;
  final Uri baseUrl;

  VChatConfig({
    this.fcmPushProvider,
    this.oneSignalPushProvider,
    required this.encryptHashKey,
    required this.baseUrl,
    this.enableLog = kDebugMode,
    this.enableMessageEncryption = false,
    this.maxGroupMembers = 512,
    this.maxBroadcastMembers = 512,

  });

  bool get isPushEnable =>
      fcmPushProvider != null || oneSignalPushProvider != null;

  VChatPushProviderBase? currentPushProviderService;

  Future cleanNotifications() async {
    if (!isPushEnable || VPlatforms.isWeb) return;
    await currentPushProviderService!.cleanAll();
  }
}
