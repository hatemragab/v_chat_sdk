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
    await _initPushService(_config.pushProvider);
    _initSocketTimer();
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

  Future<void> _initPushService(VChatPushProviderBase? pushProvider) async {
    if (pushProvider != null) {
      try {
        final initRes = await pushProvider.init();
        if (initRes) {
          _log.fine(
            "init the sdk with ${pushProvider.serviceName()} done successfully through V_CHAT_SDK",
          );
        } else {
          _log.fine(
            "init the sdk with ${pushProvider.serviceName()} done successfully From your side",
          );
        }
      } catch (err) {
        if (pushProvider.serviceName() == VChatPushService.firebase) {
          _log.warning(
            "cant init your push service ${pushProvider.serviceName()} this device may be not support google play service or not internet connection",
          );
        } else {
          _log.warning(
            "cant init your push service ${pushProvider.serviceName()} no internet connection ",
          );
        }
      }
    } else {
      _log.fine("init the sdk without push notification service!");
    }
  }

  Future<String> getPasswordFromIdentifier(String identifier) async {
    return _getHashedPassword(identifier);
  }

  Future<String?> getPushToken() async {
    if (!_config.isPushEnable) {
      return null;
    }
    final token = await _config.pushProvider!.getToken();
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
