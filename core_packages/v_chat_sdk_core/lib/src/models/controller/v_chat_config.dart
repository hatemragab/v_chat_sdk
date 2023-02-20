// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:v_chat_sdk_core/src/models/controller/config.dart';

import 'package:v_chat_sdk_core/src/models/push_provider/v_chat_push_provider.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChatConfig {
  final VPush vPush;
  final bool enableLog;
  final bool enableEndToEndMessageEncryption;
  final int maxGroupMembers;
  final int maxBroadcastMembers;
  final String encryptHashKey;
  final Uri baseUrl;

  bool get isPushEnable =>
      vPush.fcmProvider != null || vPush.oneSignalProvider != null;

  VChatPushProviderBase? currentPushProviderService;

  Future cleanNotifications() async {
    if (!isPushEnable || VPlatforms.isWeb) return;
    await currentPushProviderService!.cleanAll();
  }

//<editor-fold desc="Data Methods">
  VChatConfig({
    required this.vPush,
    required this.encryptHashKey,
    required this.baseUrl,
    this.enableLog = kDebugMode,
    this.enableEndToEndMessageEncryption = false,
    this.maxGroupMembers = 512,
    this.maxBroadcastMembers = 512,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VChatConfig &&
          runtimeType == other.runtimeType &&
          vPush == other.vPush &&
          enableLog == other.enableLog &&
          enableEndToEndMessageEncryption ==
              other.enableEndToEndMessageEncryption &&
          maxGroupMembers == other.maxGroupMembers &&
          maxBroadcastMembers == other.maxBroadcastMembers &&
          encryptHashKey == other.encryptHashKey &&
          baseUrl == other.baseUrl &&
          currentPushProviderService == other.currentPushProviderService);

  @override
  int get hashCode =>
      vPush.hashCode ^
      enableLog.hashCode ^
      enableEndToEndMessageEncryption.hashCode ^
      maxGroupMembers.hashCode ^
      maxBroadcastMembers.hashCode ^
      encryptHashKey.hashCode ^
      baseUrl.hashCode ^
      currentPushProviderService.hashCode;

  @override
  String toString() {
    return 'VChatConfig{ vPush: $vPush, enableLog: $enableLog, enableMessageEncryption: $enableEndToEndMessageEncryption, maxGroupMembers: $maxGroupMembers, maxBroadcastMembers: $maxBroadcastMembers, encryptHashKey: $encryptHashKey, baseUrl: $baseUrl, currentPushProviderService: $currentPushProviderService,}';
  }

  VChatConfig copyWith({
    VPush? vPush,
    bool? enableLog,
    bool? enableMessageEncryption,
    int? maxGroupMembers,
    int? maxBroadcastMembers,
    String? encryptHashKey,
    Uri? baseUrl,
    VChatPushProviderBase? currentPushProviderService,
  }) {
    return VChatConfig(
      vPush: vPush ?? this.vPush,
      enableLog: enableLog ?? this.enableLog,
      enableEndToEndMessageEncryption:
          enableMessageEncryption ?? enableEndToEndMessageEncryption,
      maxGroupMembers: maxGroupMembers ?? this.maxGroupMembers,
      maxBroadcastMembers: maxBroadcastMembers ?? this.maxBroadcastMembers,
      encryptHashKey: encryptHashKey ?? this.encryptHashKey,
      baseUrl: baseUrl ?? this.baseUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vPush': vPush,
      'enableLog': enableLog,
      'enableMessageEncryption': enableEndToEndMessageEncryption,
      'maxGroupMembers': maxGroupMembers,
      'maxBroadcastMembers': maxBroadcastMembers,
      'encryptHashKey': encryptHashKey,
      'baseUrl': baseUrl,
      'currentPushProviderService': currentPushProviderService,
    };
  }

  factory VChatConfig.fromMap(Map<String, dynamic> map) {
    return VChatConfig(
      vPush: map['vPush'] as VPush,
      enableLog: map['enableLog'] as bool,
      enableEndToEndMessageEncryption: map['enableMessageEncryption'] as bool,
      maxGroupMembers: map['maxGroupMembers'] as int,
      maxBroadcastMembers: map['maxBroadcastMembers'] as int,
      encryptHashKey: map['encryptHashKey'] as String,
      baseUrl: map['baseUrl'] as Uri,
    );
  }

//</editor-fold>
}
