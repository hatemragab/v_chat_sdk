import 'package:flutter/foundation.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChatConfig {
  final VChatPushProviderBase? pushProvider;
  final bool enableLog;
  final bool enableMessageEncryption;
  final int maxMediaUploadSize;
  final int maxGroupMembers;
  final int maxBroadcastMembers;
  final String encryptHashKey;
  final Uri baseUrl;

  const VChatConfig({
    this.pushProvider,
    required this.encryptHashKey,
    required this.baseUrl,
    this.enableLog = kDebugMode,
    this.enableMessageEncryption = false,
    this.maxGroupMembers = 512,
    this.maxBroadcastMembers = 512,
    this.maxMediaUploadSize = 50 * 1000 * 1000, //50 mb
  });

  bool get isPushEnable => pushProvider != null;
}
