// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

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
