// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:v_chat_sdk_core/src/models/controller/config.dart';
import 'package:v_chat_sdk_core/src/models/push_provider/v_chat_push_provider.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

typedef UserActionType = Function(
  BuildContext context,
  String id,
);

class VChatConfig {
  final VPush vPush;
  final bool enableLog;
  final bool isCallsAllowed;
  final bool enableEndToEndMessageEncryption;
  final int maxGroupMembers;
  final int maxBroadcastMembers;
  final String encryptHashKey;
  final Uri baseUrl;

  ///callback when user clicked send attachment (this current show bottom sheet with media etc ...)
  final Future<VAttachEnumRes?> Function()? onMessageAttachmentIconPress;

  //todo add onRoomItemLongPress

  ///set api if you want to make users able to pick locations
  final String? googleMapsApiKey;

  ///set max record time
  final Duration maxRecordTime;

  final UserActionType? onReportUserPress;

  final UserActionType? onUserBlockAnother;

  final UserActionType? onUserUnBlockAnother;

  ///set max upload files size default it 50 mb
  final int maxMediaSize;
  final int maxForward;
  final int compressImageQuality;

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
    this.compressImageQuality = 55,
    this.isCallsAllowed = true,
    this.maxBroadcastMembers = 512,
    this.googleMapsApiKey,
    this.onReportUserPress,
    this.onMessageAttachmentIconPress,
    this.onUserBlockAnother,
    this.onUserUnBlockAnother,
    this.maxRecordTime = const Duration(minutes: 30),
    this.maxMediaSize = 1024 * 1024 * 50,
    this.maxForward = 7,
  });

//</editor-fold>
}
