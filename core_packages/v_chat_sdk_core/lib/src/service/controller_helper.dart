// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ControllerHelper {
  final _config = VChatController.I.vChatConfig;
  final _log = Logger('ControllerHelper');
  Timer? _timer;

  ///singleton
  ControllerHelper._privateConstructor();

  static final instance = ControllerHelper._privateConstructor();

  ControllerHelper._();

  Future<ControllerHelper> init() async {
    _initLogger(_config.enableLog);
    await _initPushService(
      _config.vPush,
    );
    _initSocketTimer();
    setLocaleMessages('ar', ArMessages());
    setLocaleMessages('ar_short', ArShortMessages());
    await VAppPref.setStringKey(
      VStorageKeys.vBaseUrl.name,
      VAppConstants.baseUri.toString(),
    );
    return ControllerHelper._();
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

  Future<void> _initPushService(
    VPush vPush,
  ) async {
    final fcm = vPush.fcmProvider;
    final onesignal = vPush.oneSignalProvider;
    // if (VPlatforms.isWeb) return;
    _config.currentPushProviderService = fcm ?? onesignal;
    if (fcm != null && onesignal != null) {
      ///first try to init fcm
      final fcmInit = await fcm.init();
      if (!fcmInit) {
        ///we need to enable onesignal here
        await onesignal.init();
        _log.fine(
          "init the sdk with OneSignal done successfully through V_CHAT_SDK",
        );
      } else {
        _log.fine(
          "init the sdk with fcm done successfully through V_CHAT_SDK",
        );
      }
      return;
    }

    if (fcm != null) {
      final fcmInit = await fcm.init();
      if (!fcmInit) {
        _log.shout(
          "init the sdk with fcm didn't this may be user internet connection or device not support google play service please use onesignal",
        );
        return;
      }
      _log.fine(
        "init the sdk with fcm done successfully through V_CHAT_SDK",
      );
      return;
    }
    if (onesignal != null) {
      await onesignal.init();
      _log.fine(
        "init the sdk with OneSignal done successfully through V_CHAT_SDK",
      );
      return;
    }

    if (fcm == null && onesignal == null) {
      _log.fine("init the sdk without push notification service!");
    }
  }

  Future<String> getPasswordFromIdentifier(String identifier) async {
    return _getHashedPassword(identifier);
  }

  Future<String?> getPushToken() async {
    if (!_config.isPushEnable || VPlatforms.isWeb) {
      return null;
    }
    final token = await _config.currentPushProviderService!.getToken();
    if (token == null) {
      _log.warning(
        "FCM value is null this device will not receive notifications this may be bad network or this device not support google play service",
      );
    }

    return token;
  }

  void _initSocketTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        VEventBusSingleton.vEventBus.fire(VSocketIntervalEvent());
      },
    );
  }
}
