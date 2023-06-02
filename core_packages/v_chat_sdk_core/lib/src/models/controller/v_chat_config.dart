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

/// The `VChatConfig` class represents the configuration of VChat.
///
/// This configuration includes settings related to push notifications, logs,
/// end-to-end message encryption, and other parameters required for VChat operation.
class VChatConfig {
  /// Specifies the push provider used ([fcm] or [oneSignal]).
  final VPush vPush;

  /// Enables debug logging. Automatically disabled when [kReleaseMode] is true.
  final bool enableLog;

  /// Enables end-to-end message encryption.
  /// Only the sender and receiver can read the message messages.
  /// Messages will be encrypted and decrypted automatically in the database.
  /// it will be supported only form v 2.0.0 and above.
  final bool enableEndToEndMessageEncryption;

  /// Maximum number of members in a group.
  final int maxGroupMembers;

  /// Maximum number of forwarded or shared messages.
  final int maxForward;

  /// Maximum number of broadcast members.
  final int maxBroadcastMembers;

  /// Encryption hash key. Must be same as backend encrypt hash key and should not be changed.
  final String encryptHashKey;

  /// Base URL of VChat. Example: [vchat.example.com].
  final Uri baseUrl;

  /// Callback function executed when a user reports in the room items.
  final UserActionType? onReportUserPress;

  /// Checks whether the current platform supports background push notifications.
  bool get isCurrentPlatformsNotSupportBackgroundPush =>
      VPlatforms.isWindows || VPlatforms.isLinux || VPlatforms.isWeb;

  /// Checks if push notifications are enabled.
  bool get isPushEnable =>
      vPush.fcmProvider != null || vPush.oneSignalProvider != null;

  /// Returns the current push provider service.
  ///
  /// It checks the following conditions:
  /// - If the current platform doesn't support background push, it returns null.
  /// - If both OneSignal and FCM push providers are not defined, it returns null.
  ///
  /// If the platform is Android:
  /// - It checks Google Play Services availability.
  /// - If Google Play Services are not available and OneSignal is defined, it uses OneSignal as the push provider.
  ///
  /// If none of the above conditions are met, it will return either the FCM provider (if defined)
  /// or the OneSignal provider (if FCM provider is not defined).
  Future<VChatPushProviderBase?> get currentPushProviderService async {
    if (isCurrentPlatformsNotSupportBackgroundPush || !isPushEnable) {
      return null;
    }
    try {
      if (VPlatforms.isAndroid) {
        final availability = await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();

        if (availability != GooglePlayServicesAvailability.success &&
            vPush.oneSignalProvider != null) {
          return vPush.oneSignalProvider;
        }
      }
    } catch (err) {
      debugPrint(err.toString());
    }
    return vPush.fcmProvider ?? vPush.oneSignalProvider;
  }

  /// Clears all notifications.
  Future cleanNotifications() async {
    if (!isPushEnable || !VPlatforms.isMobile) return;
    final res = await currentPushProviderService;
    await res!.cleanAll();
  }

  /// Constructor for `VChatConfig`.
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
}
