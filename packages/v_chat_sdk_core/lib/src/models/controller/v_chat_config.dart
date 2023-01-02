import 'package:flutter/foundation.dart';

import '../../../v_chat_sdk_core.dart';

class VChatConfig {
  final VChatPushProviderBase? pushProvider;
  final bool enableLog;
  final int maxMediaUploadSize;
  final int maxGroupMembers;
  final int maxBroadcastMembers;
  final String passwordHashKey;
  final Uri baseUrl;

  const VChatConfig({
    this.pushProvider,
    required this.passwordHashKey,
    required this.baseUrl,
    this.enableLog = kDebugMode,
    this.maxGroupMembers = 512,
    this.maxBroadcastMembers = 512,
    this.maxMediaUploadSize = 50 * 1000 * 1000, //50 mb
  });

  bool get isPushEnable => pushProvider != null;
}
