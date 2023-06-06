// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:timeago/timeago.dart';
import 'package:v_chat_sdk_core/src/logger/v_logger.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/src/utils/app_pref.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VChatControllerHelper {
  final _config = VChatController.I.vChatConfig;
  final _log = Logger('ControllerHelper');
  Timer? _timer;

  ///singleton
  VChatControllerHelper._privateConstructor();

  static final instance = VChatControllerHelper._privateConstructor();

  VChatControllerHelper._();

  Future<VChatControllerHelper> init() async {
    _initLogger(_config.enableLog);
    _setupTimeAgo();
    await VAppPref.setStringKey(
      VStorageKeys.vBaseUrl.name,
      VAppConstants.baseUri.toString(),
    );

    return VChatControllerHelper._();
  }

  String _getHashedPassword(String identifier) {
    return sha512
        .convert(
          utf8.encode("${_config.encryptHashKey}_$identifier"),
        )
        .toString();
  }

  void _initLogger(bool enableLog) {
    Logger.root.level = enableLog ? Level.ALL : Level.OFF;
    Logger.root.onRecord.listen((record) {
      if (record.loggerName.startsWith("socket_io")) {
        return;
      }
      if (Level.WARNING == record.level) {
        VChatLogger.red(
          'V_CHAT_SDK (LEVEL: ${record.level.name}) (File: ${record.loggerName}) Message:${record.message}',
        );
      } else if (Level.SHOUT == record.level) {
        // ignore this log because it represent user api timeout exception
        //or user don't have internet connection
      } else {
        VChatLogger.blue(
          'V_CHAT_SDK (LEVEL: ${record.level.name}) (File: ${record.loggerName}) Message:${record.message}',
        );
      }
    });
  }

  Future<void> initPushService() async {
    final current = await _config.currentPushProviderService;
    if (current == null) {
      _log.fine("init the sdk without push notification service!");
      return;
    }
    final isInit = await current.init();
    if (isInit == false) {
      _log.warning("Notification permission not accepted");
      return;
    }
    if (current.serviceName() == VChatPushService.firebase) {
      _log.fine("init the sdk with fcm done successfully through V_CHAT_SDK");
    } else {
      _log.fine(
        "init the sdk with OneSignal done successfully through V_CHAT_SDK",
      );
    }
  }

  Future<String> getPasswordFromIdentifier(String identifier) async {
    return _getHashedPassword(identifier);
  }

  Future<String?> getPushToken() async {
    if (!_config.isPushEnable ||
        _config.isCurrentPlatformsNotSupportBackgroundPush) {
      return null;
    }
    final token = await (await _config.currentPushProviderService)?.getToken();
    if (token == null) {
      _log.warning(
        "FCM value is null this device will not receive notifications this may be bad network or this device not support google play service",
      );
    }

    return token;
  }

  void initSocketTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        VEventBusSingleton.vEventBus.fire(VSocketIntervalEvent());
      },
    );
  }

  void _setupTimeAgo() {
    setLocaleMessages('ar', ArMessages());
    setLocaleMessages('fr', FiMessages());
    setLocaleMessages('it', ItMessages());
    setLocaleMessages('ko', KoMessages());
    setLocaleMessages('uk', UkMessages());
    setLocaleMessages('vi', ViMessages());
    setLocaleMessages('pt', PtBrMessages());
    setLocaleMessages('hi', HiMessages());
    setLocaleMessages('ru', RuMessages());
    setLocaleMessages('ar_short', ArShortMessages());
  }
}
