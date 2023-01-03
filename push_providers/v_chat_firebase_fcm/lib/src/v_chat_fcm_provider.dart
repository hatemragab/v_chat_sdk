import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChatFcmProver extends VChatPushProviderBase {
  StreamSubscription? _onTokenRefresh;
  StreamSubscription? _onNewMessage;
  StreamSubscription? _onMsgClicked;
  final _vEventBusSingleton = VEventBusSingleton.vEventBus;

  @override
  Future<void> deleteToken() async {
    try {
      _onTokenRefresh?.cancel();
      await FirebaseMessaging.instance.deleteToken();
    } catch (err) {
      //
    }
    return;
  }

  @override
  Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (err) {
      //
    }
    return null;
  }

  @override
  Future<bool> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      final status =
          (await FirebaseMessaging.instance.getNotificationSettings())
              .authorizationStatus;
      if (status == AuthorizationStatus.authorized) {
        _initStreams();
        _checkIfAppOpenFromNotification();
      }
      if (Firebase.apps.isEmpty) {
        return true;
      }
      return false;
    } catch (err) {
      //
    }
    return false;
  }

  @override
  VChatPushService serviceName() {
    return VChatPushService.firebase;
  }

  @override
  Future<void> askForPermissions() async {
    try {
      final status = (await FirebaseMessaging.instance.requestPermission())
          .authorizationStatus;
      if (status == AuthorizationStatus.authorized) {
        _initStreams();
      }
    } catch (err) {
      //
    }
  }

  void _initStreams() {
    close();
    _onTokenRefresh = FirebaseMessaging.instance.onTokenRefresh.listen(
      (event) {
        _vEventBusSingleton.fire(VOnUpdateNotificationsToken(event));
      },
    );
    _onNewMessage = FirebaseMessaging.onMessage.listen((remoteMsg) {
      final msg = _getMessageMap(remoteMsg);
      if (msg != null) {
        _vEventBusSingleton.fire(VOnNewNotifications(msg));
      }
    });
    _onMsgClicked = FirebaseMessaging.onMessageOpenedApp.listen((remoteMsg) {
      final msg = _getMessageMap(remoteMsg);
      if (msg != null) {
        _vEventBusSingleton.fire(VOnNotificationsClickedEvent(msg));
      }
    });
  }

  void _checkIfAppOpenFromNotification() async {
    await Future.delayed(const Duration(seconds: 2));
    final remoteMsg = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMsg != null) {
      final msg = _getMessageMap(remoteMsg);
      if (msg != null) {
        _vEventBusSingleton.fire(VOnNotificationsClickedEvent(msg));
      }
    }
  }

  Map<String, dynamic>? _getMessageMap(RemoteMessage remoteMessage) {
    return {};
  }

  @override
  void close() {
    _onTokenRefresh?.cancel();
    _onNewMessage?.cancel();
    _onMsgClicked?.cancel();
  }
}
