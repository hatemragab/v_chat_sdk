// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/service/call_listener.dart';
import 'package:v_chat_sdk_core/src/service/controller_helper.dart';
import 'package:v_chat_sdk_core/src/service/events_daemon.dart';
import 'package:v_chat_sdk_core/src/service/offline_online_emitter_service.dart';
import 'package:v_chat_sdk_core/src/service/re_send_daemon.dart';
import 'package:v_chat_sdk_core/src/service/v_app_lifecycle_state.dart';
import 'package:v_chat_sdk_core/src/user_apis/auth/auth.dart';
import 'package:v_chat_sdk_core/src/user_apis/block/block.dart';
import 'package:v_chat_sdk_core/src/user_apis/room/room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Represents a controller for VChat.
///
/// It must be initialized before used using [init] method. After
/// it's initialized, it can be accessed using the [I] getter.
///
/// Example:
///
/// ```dart
/// await VChatController.init(...)
/// final i = VChatController.I;
/// ```
class VChatController {
  /// Logger instance
  final _log = Logger('VChatController');

  /// Private constructor for singleton implementation.
  VChatController._();

  /// Singleton instance
  static final _instance = VChatController._();

  /// Returns the singleton instance of [VChatController].
  /// It should be accessed only after calling [init], otherwise it'll
  /// throw an error.
  static VChatController get I => _instance;

  /// Profile API instance
  late final VProfileApi profileApi;

  /// Room API instance
  late final RoomApi roomApi;

  /// Block API instance
  late final Block blockApi;

  /// VChat configuration instance
  late VChatConfig vChatConfig;

  /// Navigator instance
  late final VNavigator vNavigator;

  /// Navigator key
  late final GlobalKey<NavigatorState> navigatorKey;

  /// Native API instance
  late final VNativeApi nativeApi;

  /// Indicates whether the controller is initialized
  bool _isControllerInit = false;

  /// Initialize the [VChatController] instance.
  ///
  /// It needs to be called before accessing the instance via the [I] getter.
  /// The parameters [vChatConfig], [vNavigator] and [navigatorKey] are
  /// required to initialize the controller.
  ///
  /// Returns the initialized instance of [VChatController].
  static Future<VChatController> init({
    required VChatConfig vChatConfig,
    required VNavigator vNavigator,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    assert(!_instance._isControllerInit);
    await _instance._initialize(vChatConfig, vNavigator, navigatorKey);
    return _instance;
  }

  /// Private initializer to initialize the instance fields and start services.
  Future<void> _initialize(
    VChatConfig vChatConfig,
    VNavigator vNavigator,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    _isControllerInit = true;
    this.vChatConfig = vChatConfig;
    this.navigatorKey = navigatorKey;
    this.vNavigator = vNavigator;
    await VAppPref.init();
    nativeApi = await VNativeApi.init();
    profileApi = VProfileApi(nativeApi, this.vChatConfig);
    roomApi = RoomApi(nativeApi);
    blockApi = Block(nativeApi);
    await VChatControllerHelper.instance.init();
    _startServices();
  }

  /// The navigation context based on the navigator key.
  BuildContext get navigationContext => navigatorKey.currentContext!;

  /// Sets [_isControllerInit] to false indicating that the controller is not initialized.
  void dispose() {
    _isControllerInit = false;
  }

  /// Updates the chat configuration.
  void updateConfig(VChatConfig chatConfig) {
    vChatConfig = chatConfig;
  }

  /// Connects to the socket if there is an access token. Otherwise, logs a
  /// warning and returns false. This method assumes you've already logged in.
  ///
  /// Returns true if successfully connected to the socket, false otherwise.
  bool connectToSocket() {
    final access =
        VAppPref.getHashedString(key: VStorageKeys.vAccessToken.name);
    if (access == null) {
      _log.warning(
        "You try to connect to socket without login. Please make sure you call VChatController.instance.login first.",
      );
      return false;
    }
    SocketController.instance.connect();
    return true;
  }

  /// Starts the required services for the controller.
  static void _startServices() {
    VAppLifecycleState();
    ReSendDaemon().start();
    EventsDaemon().start();
    OfflineOnlineEmitterService().start();

    CallListener(
      _instance.nativeApi,
      _instance.vChatConfig,
      _instance.vNavigator,
    );
  }

  /// Updates the language code in the app preferences.
  ///
  /// [languageCode] is the new language code to be set.
  Future<void> updateLanguageCode(String languageCode) =>
      VAppPref.setStringKey(VStorageKeys.vAppLanguage.name, languageCode);
}
