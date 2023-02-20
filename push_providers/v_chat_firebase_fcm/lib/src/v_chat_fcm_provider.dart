// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:eraser/eraser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:http/http.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChatFcmProver extends VChatPushProviderBase {
  StreamSubscription? _onTokenRefresh;
  StreamSubscription? _onNewMessage;
  StreamSubscription? _onMsgClicked;
  final _vEventBusSingleton = VEventBusSingleton.vEventBus;

  @override
  Future<void> deleteToken() async {
    try {
      await cleanAll();
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
      FirebaseMessaging.onBackgroundMessage(
        vFirebaseMessagingBackgroundHandler,
      );
      final status =
          (await FirebaseMessaging.instance.getNotificationSettings())
              .authorizationStatus;
      if (status == AuthorizationStatus.authorized) {
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
      final String? fromVChat = remoteMsg.data['fromVChat'];
      final String? message = remoteMsg.data['vMessage'];
      // final String? type = remoteMsg.data['type'];
      if (fromVChat != null && message != null) {
        final msg = MessageFactory.createBaseMessage(
          jsonDecode(message),
        );
        if (msg.isMeSender) return;
        _vEventBusSingleton.fire(VOnNewNotifications(
          message: msg,
        ));
      }
    });
    _onMsgClicked =
        FirebaseMessaging.onMessageOpenedApp.listen((remoteMsg) async {
      final String? fromVChat = remoteMsg.data['fromVChat'];
      final String? message = remoteMsg.data['vMessage'];

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
    final remoteMsg = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMsg == null) return null;
    final String? fromVChat = remoteMsg.data['fromVChat'];
    final String? message = remoteMsg.data['vMessage'];
    if (fromVChat != null && message != null) {
      final msg = MessageFactory.createBaseMessage(jsonDecode(message));
      if (msg.messageType.isCall) return null;
      return msg;
    }
    return null;
  }

  @override
  void close() {
    _onTokenRefresh?.cancel();
    _onNewMessage?.cancel();
    _onMsgClicked?.cancel();
  }

  @override
  Future<VBaseMessage?> getOpenAppNotification() {
    return _checkIfAppOpenFromNotification();
  }

  @override
  Future<void> cleanAll({int? notificationId}) async {
    await Eraser.clearAllAppNotifications();
    FlutterAppBadger.removeBadge();
  }
}

@pragma('vm:entry-point')
Future<void> vFirebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (await FlutterAppBadger.isAppBadgeSupported()) {
    FlutterAppBadger.updateBadgeCount(1);
  }
  await VAppPref.init();
  final String? fromVChat = message.data['fromVChat'];
  final String? vMessage = message.data['vMessage'];
  if (fromVChat == null || vMessage == null) return Future<void>.value();
  final msg = MessageFactory.createBaseMessage(
    jsonDecode(vMessage) as Map<String, dynamic>,
  );
  final token = VAppPref.getHashedString(key: VStorageKeys.vAccessToken.name);
  if (token != null) {
    try {
      await setDeliverForThisRoom(msg.roomId, token);
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }
  final x = VLocalNativeApi();
  await x.init();
  final insertRes = await x.message.safeInsertMessage(msg);
  if (insertRes == 1) {
    await x.room.updateRoomUnreadCountAddOne(msg.roomId);
  }
  return Future<void>.value();
}

@pragma('vm:entry-point')
Future setDeliverForThisRoom(String roomId, String token) async {
  final baseUrl = VAppPref.getStringOrNullKey(VStorageKeys.vBaseUrl.name);
  final res = await patch(
    Uri.parse(
      "$baseUrl/channel/$roomId/deliver",
    ),
    headers: {
      'authorization': "Bearer $token",
      "clint-version": VAppConstants.clintVersion,
      "Accept-Language": "en"
    },
  );
  if (res.statusCode != 200) {
    throw "cant deliver the message status in background for ${VPlatforms.currentPlatform}";
  }
}
