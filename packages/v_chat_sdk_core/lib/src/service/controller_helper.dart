import 'dart:async';

import 'package:logging/logging.dart';

import '../../v_chat_sdk_core.dart';
import '../logger/v_logger.dart';
import '../utils/event_bus.dart';

class ControllerHelper {
  late final VChatConfig _config;
  final _log = Logger('ControllerHelper');
  Timer? _timer;

  ///singleton
  ControllerHelper._privateConstructor();

  static final instance = ControllerHelper._privateConstructor();

  ControllerHelper._();

  Future<ControllerHelper> init(
    final VChatConfig config,
  ) async {
    _config = config;
    _initLogger(config.enableLog);
    await _initPushService(config.pushProvider);
    _initSocketTimer();
    return ControllerHelper._();
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
              "init the sdk with ${pushProvider.serviceName()} done successfully through V_CHAT_SDK");
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
    return identifier;
  }

  Future<String?> getFcmToken() async {
    if (!_config.isPushEnable) {
      return null;
    }
    try {
      return await _config.pushProvider!.getToken();
    } catch (err) {
      _log.warning(err);
    }
    return null;
  }

  void _initSocketTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        EventBusSingleton.instance.vChatEvents.fire(VSocketIntervalEvent());
      },
    );
  }

  void onClose() {
    _timer?.cancel();
  }
}
