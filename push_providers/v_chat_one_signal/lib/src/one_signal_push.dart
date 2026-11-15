// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:developer';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:eraser/eraser.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VChatOneSignalProver extends VChatPushProviderBase {
  final _vEventBusSingleton = VEventBusSingleton.vEventBus;
  final String appId;
  final OSLogLevel logLevel;
  bool _streamsInitialized = false;

  VChatOneSignalProver({required this.appId, this.logLevel = OSLogLevel.none});

  @override
  Future<void> deleteToken() async {
    try {
      await cleanAll();
      await OneSignal.User.pushSubscription.optOut();
    } catch (err) {
      //
    }
    return;
  }

  @override
  Future<String?> getToken() async {
    try {
      final subscriptionId = OneSignal.User.pushSubscription.id;
      if (subscriptionId == null) {
        if (kDebugMode) {
          log('The OneSignal push subscription ID is not available yet.');
        }
        return null;
      }
      return subscriptionId;
    } catch (err) {
      //
    }
    return null;
  }

  Future<bool> _getIsAllow() async {
    return OneSignal.Notifications.permission;
  }

  @override
  Future<bool> init() async {
    try {
      if (kReleaseMode) {
        await OneSignal.Debug.setLogLevel(OSLogLevel.none);
      } else {
        await OneSignal.Debug.setLogLevel(logLevel);
      }
      await OneSignal.initialize(appId);
      final status = await _getIsAllow();
      if (status) {
        _initStreams();
      }
      return true;
    } catch (err) {
      //
    }
    return false;
  }

  @override
  VChatPushService serviceName() {
    return VChatPushService.onesignal;
  }

  @override
  Future<void> askForPermissions() async {
    try {
      await OneSignal.Notifications.requestPermission(true);
      if (await _getIsAllow()) {
        _initStreams();
      } else {
        log("user not accept to send notifications!");
      }
    } catch (err) {
      //
    }
  }

  void _initStreams() {
    if (_streamsInitialized) return;
    _streamsInitialized = true;
    OneSignal.Notifications.addForegroundWillDisplayListener(
      _onNotificationWillDisplay,
    );
    OneSignal.User.pushSubscription.addObserver(_onSubscriptionChanged);
    OneSignal.Notifications.addClickListener(_onNotificationClicked);
  }

  void _onNotificationWillDisplay(OSNotificationWillDisplayEvent event) {
    event.preventDefault();
    final data = event.notification.additionalData;
    if (data == null) return;
    final fromVChat = data['fromVChat'] as String?;
    final message = data['vMessage'] as String?;
    if (fromVChat == null || message == null) return;
    final msg = MessageFactory.createBaseMessage(jsonDecode(message));
    if (msg.isMeSender) return;
    _vEventBusSingleton.fire(VOnNewNotifications(message: msg));
  }

  void _onSubscriptionChanged(OSPushSubscriptionChangedState changes) {
    final subscriptionId = changes.current.id;
    if (subscriptionId == null) return;
    _vEventBusSingleton.fire(VOnUpdateNotificationsToken(subscriptionId));
  }

  Future<void> _onNotificationClicked(OSNotificationClickEvent event) async {
    final data = event.notification.additionalData;
    if (data == null) return;
    final fromVChat = data['fromVChat'] as String?;
    final message = data['vMessage'] as String?;
    if (fromVChat == null || message == null) return;
    final msg = MessageFactory.createBaseMessage(jsonDecode(message));
    final room = await _getRoom(msg.roomId);
    if (room == null) return;
    _vEventBusSingleton.fire(
      VOnNotificationsClickedEvent(message: msg, room: room),
    );
  }

  Future<VRoom?> _getRoom(String roomId) async {
    return VChatController.I.nativeApi.local.room.getOneWithLastMessageByRoomId(
      roomId,
    );
  }

  Future<VBaseMessage?> _checkIfAppOpenFromNotification() async {
    return null;
  }

  @override
  void close() {
    if (!_streamsInitialized) return;
    OneSignal.Notifications.removeForegroundWillDisplayListener(
      _onNotificationWillDisplay,
    );
    OneSignal.User.pushSubscription.removeObserver(_onSubscriptionChanged);
    OneSignal.Notifications.removeClickListener(_onNotificationClicked);
    _streamsInitialized = false;
  }

  // @override
  // Stream<VNotificationModel> eventsStream() => _eventsStream.stream;

  @override
  Future<VBaseMessage?> getOpenAppNotification() {
    return _checkIfAppOpenFromNotification();
  }

  @override
  Future<void> cleanAll({int? notificationId}) async {
    if (notificationId != null) {
      await OneSignal.Notifications.removeNotification(notificationId);
      return;
    }
    await OneSignal.Notifications.clearAll();
    await Eraser.clearAllAppNotifications();
    await AppBadgePlus.updateBadge(0);
  }
}
