import 'package:logging/logging.dart';

import '../../v_chat_sdk_core.dart';
import '../logger/v_logger.dart';

class ControllerHelper {
  final VChatConfig config;
  final log = Logger('ControllerHelper');

  ControllerHelper(this.config);

  void initLogger(bool enableLog) {
    Logger.root.level = enableLog ? Level.ALL : Level.OFF;
    Logger.root.onRecord.listen((record) {
      if (Level.WARNING == record.level) {
        VChatLogger.red(
          'V_CHAT_SDK (LEVEL: ${record.level.name}) (File: ${record.loggerName}) Message:${record.message}',
        );
      } else {
        VChatLogger.blue(
          'V_CHAT_SDK (LEVEL: ${record.level.name}) (File: ${record.loggerName}) Message:${record.message}',
        );
      }
    });
  }

  Future<void> initPushService(VChatPushProviderBase? pushProvider) async {
    if (pushProvider != null) {
      try {
        final initRes = await pushProvider.init();
        if (initRes) {
          log.fine(
              "init the sdk with ${pushProvider.serviceName()} done successfully through V_CHAT_SDK");
        } else {
          log.fine(
            "init the sdk with ${pushProvider.serviceName()} done successfully From your side",
          );
        }
      } catch (err) {
        if (pushProvider.serviceName() == VChatPushService.firebase) {
          log.warning(
            "cant init your push service ${pushProvider.serviceName()} this device may be not support google play service or not internet connection",
          );
        } else {
          log.warning(
            "cant init your push service ${pushProvider.serviceName()} no internet connection ",
          );
        }
      }
    } else {
      log.fine("init the sdk without push notification service!");
    }
  }

  Future<String> getPasswordFromIdentifier(String identifier) async {
    return identifier;
  }

  Future<String?> getFcmToken() async {
    if (!config.isPushEnable) {
      return null;
    }
    try {
      return await config.pushProvider!.getToken();
    } catch (err) {
      log.warning(err);
    }
    return null;
  }
}
