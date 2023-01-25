import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:eraser/eraser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChatOneSignalProver extends VChatPushProviderBase {
  final _vEventBusSingleton = VEventBusSingleton.vEventBus;
  final String appId;
  final OSLogLevel logLevel;

  VChatOneSignalProver({
    super.enableForegroundNotification,
    required this.appId,
    this.logLevel = OSLogLevel.none,
    super.vPushConfig =
        const VLocalNotificationPushConfig(channelName: "channelName"),
  });

  @override
  Future<void> deleteToken() async {
    try {
      cleanAll();
      await OneSignal.shared.disablePush(false);
    } catch (err) {
      //
    }
    return;
  }

  @override
  Future<String?> getToken() async {
    try {
      final state = await OneSignal.shared.getDeviceState();
      if (state == null) {
        if (kDebugMode) {
          print("OneSignal.shared.getDeviceState() is null!");
        }
        return null;
      }
      return state.userId;
    } catch (err) {
      //
    }
    return null;
  }

  Future<bool> _getIsAllow() async {
    final state = await OneSignal.shared.getDeviceState();
    if (state == null) return false;
    return state.hasNotificationPermission;
  }

  @override
  Future<bool> init() async {
    try {
      if (kReleaseMode) {
        await OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);
      } else {
        await OneSignal.shared.setLogLevel(logLevel, logLevel);
      }
      await OneSignal.shared.setAppId(appId);
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
      await OneSignal.shared.promptUserForPushNotificationPermission();
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
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      final data = event.notification.additionalData;
      if (data == null) return;
      final String? fromVChat = data['fromVChat'];
      final String? message = data['vMessage'];
      if (fromVChat != null && message != null) {
        final msg = MessageFactory.createBaseMessage(
          jsonDecode(message),
        );
        if (msg.isMeSender) return;
        _vEventBusSingleton.fire(VOnNewNotifications(
          message: msg,
        ));
      }
      event.complete(null);
    });
    OneSignal.shared.setSubscriptionObserver((changes) {
      _vEventBusSingleton.fire(VOnUpdateNotificationsToken(changes.to.userId!));
    });
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      // Will be called whenever a notification is opened/button pressed.
      final data = result.notification.additionalData;

      if (data == null) return;
      final String? fromVChat = data['fromVChat'];
      final String? message = data['vMessage'];

      if (fromVChat != null && message != null) {
        final msg = MessageFactory.createBaseMessage(
          jsonDecode(message),
        );
        final room = await _getRoom(msg.roomId);
        if (room == null) return;
        _vEventBusSingleton
            .fire(VOnNotificationsClickedEvent(message: msg, room: room));
      }
    });
  }

  Future<VRoom?> _getRoom(String roomId) async {
    return VChatController.I.nativeApi.local.room
        .getOneWithLastMessageByRoomId(roomId);
  }

  Future<VBaseMessage?> _checkIfAppOpenFromNotification() async {
    return null;
  }

  @override
  void close() {}

  // @override
  // Stream<VNotificationModel> eventsStream() => _eventsStream.stream;

  @override
  Future<VBaseMessage?> getOpenAppNotification() {
    return _checkIfAppOpenFromNotification();
  }

  @override
  Future<void> cleanAll({int? notificationId}) async {
    if (notificationId != null) {
      OneSignal.shared.removeNotification(notificationId);
      return;
    }
    // await OneSignal.shared.clearOneSignalNotifications();
    await Eraser.clearAllAppNotifications();
    FlutterAppBadger.removeBadge();
  }
}
