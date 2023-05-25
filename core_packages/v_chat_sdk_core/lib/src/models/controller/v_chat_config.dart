// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:v_chat_sdk_core/src/models/controller/config.dart';
import 'package:v_chat_sdk_core/src/models/push_provider/v_chat_push_provider.dart';
import 'package:v_platform/v_platform.dart';

typedef UserActionType = Function(
  BuildContext context,
  String id,
);

class VChatConfig {
  final VPush vPush;
  final bool enableLog;
  //not working yet
  final bool enableEndToEndMessageEncryption;
  final int maxGroupMembers;
  final int maxForward;
  final int maxBroadcastMembers;
  final String encryptHashKey;
  final Uri baseUrl;

  //todo add onRoomItemLongPress

  final UserActionType? onReportUserPress;

  bool get isCurrentPlatformsNotSupportBackgroundPush {
    return VPlatforms.isWindows || VPlatforms.isLinux || VPlatforms.isWeb;
  }

  bool get isPushEnable =>
      vPush.fcmProvider != null || vPush.oneSignalProvider != null;

  Future<VChatPushProviderBase?> get currentPushProviderService async {
    if (isCurrentPlatformsNotSupportBackgroundPush) return null;
    try {
      if (VPlatforms.isAndroid) {
        final availability = await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();

        if (availability != GooglePlayServicesAvailability.success) {
          return vPush.oneSignalProvider;
        }
      }
    } catch (err) {
      debugPrint(err.toString());
    }
    return vPush.fcmProvider ?? vPush.oneSignalProvider;
  }

  Future cleanNotifications() async {
    if (!isPushEnable || !VPlatforms.isMobile) return;
    final res = await currentPushProviderService;
    await res!.cleanAll();
  }

//<editor-fold desc="Data Methods">
  VChatConfig({
    required this.vPush,
    required this.encryptHashKey,
    required this.baseUrl,
    this.enableLog = kDebugMode,
    this.enableEndToEndMessageEncryption = false,
    this.maxGroupMembers = 512,
    this.maxForward = 7,
    this.maxBroadcastMembers = 512,
    this.onReportUserPress,
  });

//</editor-fold>
}
