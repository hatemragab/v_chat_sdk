// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/service/call_listener.dart';
import 'package:v_chat_sdk_core/src/service/controller_helper.dart';
import 'package:v_chat_sdk_core/src/service/events_daemon.dart';
import 'package:v_chat_sdk_core/src/service/notification_listener.dart';
import 'package:v_chat_sdk_core/src/service/offline_online_emitter_service.dart';
import 'package:v_chat_sdk_core/src/service/re_send_daemon.dart';
import 'package:v_chat_sdk_core/src/service/socket_status_service.dart';
import 'package:v_chat_sdk_core/src/service/v_app_lifecycle_state.dart';
import 'package:v_chat_sdk_core/src/user_apis/auth/auth.dart';
import 'package:v_chat_sdk_core/src/user_apis/block/block.dart';
import 'package:v_chat_sdk_core/src/user_apis/room/room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

/// VChatController instance.
///
/// It must be initialized before used, otherwise an error is thrown.
///
/// ```dart
/// await VChatController.init(...)
/// ```
///
/// Use it:
///
/// ```dart
/// final i = VChatController.I;
/// ```
class VChatController {
  final _log = Logger('VChatController');

  ///singleton
  VChatController._();

  static final _instance = VChatController._();

  static VChatController get I {
    assert(
      _instance._isControllerInit,
      'You must initialize the v chat controller instance before calling VChatController.I',
    );
    return _instance;
  }

  late final VProfileApi profileApi;
  late final RoomApi roomApi;
  late final Block blockApi;
  late VChatConfig vChatConfig;
  late final VNavigator vNavigator;
  bool _isControllerInit = false;
  late final VNativeApi nativeApi;

  late final GlobalKey<NavigatorState> navigatorKey;

  /// Initialize the [VChatController] instance.
  ///
  /// It's necessary to initialize before calling [VChatController.I]
  static Future<VChatController> init({
    required VChatConfig vChatConfig,
    required VNavigator vNavigator,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    assert(
      !_instance._isControllerInit,
      'This controller is already initialized',
    );
    _instance._isControllerInit = true;
    _instance.vChatConfig = vChatConfig;
    _instance.navigatorKey = navigatorKey;
    _instance.vNavigator = vNavigator;
    await VAppPref.init();
    _instance.nativeApi = await VNativeApi.init();
    _instance.profileApi = VProfileApi(
      _instance.nativeApi,
      _instance.vChatConfig,
    );
    _instance.roomApi = RoomApi(
      _instance.nativeApi,
    );
    _instance.blockApi = Block(
      _instance.nativeApi,
    );
    await ControllerHelper.instance.init();
    SocketController.instance.connect();
    _startServices();

    return _instance;
  }

  BuildContext get navigationContext => navigatorKey.currentContext!;

  void dispose() {
    _isControllerInit = false;
  }

  void updateConfig(VChatConfig chatConfig) {
    vChatConfig = chatConfig;
  }

  ///make sure you already login or already login to v chat
  bool connectToSocket() {
    final access =
        VAppPref.getHashedString(key: VStorageKeys.vAccessToken.name);
    if (access == null) {
      _log.warning(
        "You try to connect to socket with out login please make sure you call VChatController.instance.login first",
      );
      return false;
    }
    SocketController.instance.connect();
    return true;
  }

  static void _startServices() {
    VAppLifecycleState();
    ReSendDaemon().start();
    EventsDaemon().start();
    OfflineOnlineEmitterService().start();
    SocketStatusService();
    VNotificationListener(
      _instance.nativeApi,
      _instance.vChatConfig,
      _instance.vNavigator,
    );
    CallListener(
      _instance.nativeApi,
      _instance.vChatConfig,
      _instance.vNavigator,
    );
  }

  Future<void> updateLanguageCode(String languageCode) =>
      VAppPref.setStringKey(VStorageKeys.vAppLanguage.name, languageCode);
}
