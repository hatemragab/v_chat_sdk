// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:platform_local_notifications/platform_local_notifications.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// A singleton class that listens to notifications.
class VNotificationListener {
  final _log = Logger('VNotificationListener');

  // Configuration of the VChat
  final vChatConfig = VChatController.I.vChatConfig;

  // Access to native APIs
  final nativeApi = VChatController.I.nativeApi;

  // Navigator instance
  final vNavigator = VChatController.I.vNavigator;

  // Singleton instance
  static final _instance = VNotificationListener._();

  // Track if the controller has been initialized
  bool _isControllerInit = false;

  VNotificationListener._();

  /// Returns the instance of [VNotificationListener].
  ///
  /// Throws an [AssertionError] if [VNotificationListener] hasn't been initialized.
  static VNotificationListener get I {
    assert(
      _instance._isControllerInit,
      'You must initialize the v chat controller instance before calling VChatController.I',
    );
    return _instance;
  }

  /// Initializes the [VNotificationListener].
  ///
  /// If it's already initialized, does nothing.
  static Future<void> init() async {
    if (_instance._isControllerInit) return;
    _instance._isControllerInit = true;
    await _instance._init();
  }

  /// Marks the room as seen.
  ///
  /// Emits a "seen room message" event and updates the unread count to zero.
  Future<void> _setRoomSeen(String roomId) async {
    VChatController.I.nativeApi.remote.socketIo.emitSeenRoomMessages(roomId);
    await VChatController.I.nativeApi.local.room.updateRoomUnreadToZero(roomId);
  }

  /// Initializes the notification listener.
  ///
  /// It listens to notifications, updates room's seen status, and navigates to message page.
  Future<void> _init() async {
    if (vChatConfig.vPush.enableVForegroundNotification &&
        vChatConfig.isPushEnable) {
      await PlatformNotifier.I.init(appName: "v_chat_sdk");
      await PlatformNotifier.I.requestPermissions();
      PlatformNotifier.I.platformNotifierStream.listen((event) async {
        if (event.payload!.isEmpty) return;
        if (event is PluginNotificationReplyAction) {
          final txtMessage = VTextMessage.buildMessage(
            content: event.text,
            isEncrypted: vChatConfig.enableEndToEndMessageEncryption,
            roomId: event.payload!,
          );
          await MessageUploaderQueue.instance.addToQueue(
            await MessageFactory.createUploadMessage(txtMessage),
          );
          return;
        }
        if (event is PluginNotificationMarkRead) {
          await _setRoomSeen(event.payload!);
          return;
        }
        if (event is PluginNotificationClickAction) {
          final room = await VChatController.I.nativeApi.local.room
              .getOneWithLastMessageByRoomId(event.payload!);
          if (room == null) return;
          vNavigator.messageNavigator
              .toMessagePage(VChatController.I.navigationContext, room);
          return;
        }
      });
      nativeApi.streams.vOnNewNotificationStream.listen((event) {
        final message = event.message;
        final isRoomOpen = VRoomTracker.instance.isRoomOpen(message.roomId);
        if (!isRoomOpen && !message.isMeSender) {
          PlatformNotifier.I.showChatNotification(
            model: ShowPluginNotificationModel(
              id: message.hashCode,
              title: message.senderName,
              payload: message.roomId,
              body: message.realContentMentionParsedWithAt,
            ),
            userImage: message.senderImageThumb,
            userName: message.senderName,
            conversationTitle: message.senderName,
            context: VChatController.I.navigationContext,
          );
        }
      });
    }
    nativeApi.streams.vOnNotificationsClickedStream.listen((event) {
      final message = event.message;
      final room = event.room;
      final isRoomOpen = VRoomTracker.instance.isRoomOpen(message.roomId);
      if (isRoomOpen) return;
      if (VChatController.I.navigatorKey.currentContext == null) {
        _log.shout(
          "(vOnNotificationsClickedStream) please set the navigatorKey context to handle the notification click VChatController.I.init(navigatorKey:)",
        );
        return;
      }
      vNavigator.messageNavigator
          .toMessagePage(VChatController.I.navigationContext, room);
    });
    if (!vChatConfig.isPushEnable) return;
    nativeApi.streams.vOnUpdateNotificationsTokenStream.listen((event) async {
      await nativeApi.remote.profile.addFcm(event.token);
    });
    getOpenAppNotification();
  }

  /// Fetches room information based on [roomId].
  Future<VRoom?> _getRoom(String roomId) async {
    return VChatController.I.nativeApi.local.room
        .getOneWithLastMessageByRoomId(roomId);
  }

  /// Handles an open application notification.
  Future<void> getOpenAppNotification() async {
    final currentPush = await vChatConfig.currentPushProviderService;
    if (currentPush == null) return;
    if (currentPush.serviceName() == VChatPushService.onesignal) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 200));
    final message = await (await vChatConfig.currentPushProviderService)!
        .getOpenAppNotification();
    if (message == null) return;
    final room = await _getRoom(message.roomId);
    final isRoomOpen = VRoomTracker.instance.isRoomOpen(message.roomId);
    if (room == null || isRoomOpen) return;
    if (VChatController.I.navigatorKey.currentContext == null) {
      _log.shout(
        "(vOnNotificationsClickedStream) please set the navigatorKey context to handle the notification click VChatController.I.init(navigatorKey:)",
      );
      return;
    }
    vNavigator.messageNavigator.toMessagePage(
      VChatController.I.navigationContext,
      room,
    );
  }
}
