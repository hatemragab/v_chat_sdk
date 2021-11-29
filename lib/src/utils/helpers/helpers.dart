import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../enums/message_type.dart';
import '../../services/v_chat_app_service.dart';

class Helpers {
  Helpers._();
  static String baseName(String path) {
    return basename(path);
  }

  static void vlog(String err) {
    if (VChatAppService.instance.enableLog) {
      printWarning("⚠️ V_CHAT_SDK SAY =>>> $err");
    }
  }

  static printError(String text) {
    print('\x1B[31m$text\x1B[0m');
  }

  static printWarning(String text) {
    print('\x1B[33m$text\x1B[0m');
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static DateTime getLocalTime(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toLocal();
  }

  // ignore: type_annotate_public_apis
  static get getCreatedAtUtc => DateTime.now().toUtc().millisecondsSinceEpoch;

  static bool isMessageHasAttachment(MessageType t) {
    return t != MessageType.text && t != MessageType.info && t != MessageType.allDeleted;
  }
}
