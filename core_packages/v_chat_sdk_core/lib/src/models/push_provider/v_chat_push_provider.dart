// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// An abstract base class for providing push notification services.
abstract class VChatPushProviderBase {
  const VChatPushProviderBase();

  /// Initializes the push provider.
  ///
  /// Returns a [Future] that completes with a [bool] indicating the success of the initialization.
  Future<bool> init();

  /// Gets the token for the push provider.
  ///
  /// Returns a [Future] that completes with a [String] representing the token, or null if there is no token.
  Future<String?> getToken();

  /// Deletes the token for the push provider.
  ///
  /// Returns a [Future] that completes when the token is deleted.
  Future<void> deleteToken();

  /// Cleans all the notifications.
  ///
  /// [notificationId] can be specified to clean a specific notification, otherwise all notifications will be cleaned.
  ///
  /// Returns a [Future] that completes when the notifications are cleaned.
  Future<void> cleanAll({
    int? notificationId,
  });

  /// Asks for permission to display notifications.
  ///
  /// Returns a [Future] that completes when the user response is received.
  Future<void> askForPermissions();

  /// Gets the notification that caused the app to open.
  ///
  /// Returns a [Future] that completes with a [VBaseMessage] representing the notification message,
  /// or null if the app was not opened due to a notification.
  Future<VBaseMessage?> getOpenAppNotification();

  /// Closes the push provider.
  void close();

  /// Returns the service name of the push provider.
  VChatPushService serviceName();
}
