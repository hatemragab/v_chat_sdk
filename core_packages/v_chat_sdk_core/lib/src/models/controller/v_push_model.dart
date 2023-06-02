// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

///you can provide the both [VChatPushProviderBase] for fcm and one signal and v chat will handle the switch between them
///if your app run on mobile that not support fcm then v chat will use one signal
class VPush {
  /// Enable foreground notification by v chat service if you disable it you need to configure your own foreground notification
  /// by listen to [VChatController.I.nativeApi.streams.vOnNewNotificationStream]
  final bool enableVForegroundNotification;

  /// Configure your local notification by [VLocalNotificationPushConfig] to control v chat notification
  final VLocalNotificationPushConfig vPushConfig;

  /// if you want to use firebase cloud messaging as push notification provider
  final VChatPushProviderBase? fcmProvider;

  /// if you want to use one signal as push notification provider
  final VChatPushProviderBase? oneSignalProvider;

  VPush({
    required this.enableVForegroundNotification,
    required this.vPushConfig,
    this.fcmProvider,
    this.oneSignalProvider,
  });

  VPush copyWith({
    bool? enableVForegroundNotification,
    VLocalNotificationPushConfig? vPushConfig,
    VChatPushProviderBase? fcmProvider,
    VChatPushProviderBase? oneSignalProvider,
  }) {
    return VPush(
      enableVForegroundNotification:
          enableVForegroundNotification ?? this.enableVForegroundNotification,
      vPushConfig: vPushConfig ?? this.vPushConfig,
      fcmProvider: fcmProvider ?? this.fcmProvider,
      oneSignalProvider: oneSignalProvider ?? this.oneSignalProvider,
    );
  }
}
