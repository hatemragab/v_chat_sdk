import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:v_chat_sdk/src/enums/message_type.dart';
import 'package:v_chat_sdk/src/models/v_chat_message.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

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

  static void printError(String text) {
    if (kDebugMode) {
      print('\x1B[31m$text\x1B[0m');
    }
  }

  static void printWarning(String text) {
    if (kDebugMode) {
      print('\x1B[33m$text\x1B[0m');
    }
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static DateTime getLocalTime(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toLocal();
  }

  static int get getCreatedAtUtc =>
      DateTime.now().toUtc().millisecondsSinceEpoch;

  static String getMessageBody(VChatMessage m, VChatLookupString trans) {
    if (m.messageType == MessageType.create) {
      return "${m.senderName} ${trans.createTheGroup()}";
    }

    if (m.messageType == MessageType.image) {
      return trans.thisContentIsImage();
    }
    if (m.messageType == MessageType.file) {
      return trans.thisContentIsFile();
    }
    if (m.messageType == MessageType.voice) {
      return trans.thisContentIsVoice();
    }
    if (m.messageType == MessageType.video) {
      return trans.thisContentIsVideo();
    }

    if (m.messageType == MessageType.join) {
      return "${m.content} ${trans.joinedTheGroupChat()}";
    }
    if (m.messageType == MessageType.leave) {
      return "${m.content} ${trans.leftGroupChat()}";
    }
    if (m.messageType == MessageType.add) {
      return "${m.content} ${trans.addedBy()} ${m.senderName}";
    }
    if (m.messageType == MessageType.info) {
      return "${m.senderName} ${trans.updateGroupData()}";
    }

    if (m.messageType == MessageType.upgrade) {
      return "${m.content} ${trans.upgradedToAdminBy()} ${m.senderName}";
    }
    if (m.messageType == MessageType.downgrade) {
      return "${m.content} ${trans.downgradeToMemberBy()} ${m.senderName}";
    }
    if (m.messageType == MessageType.kick) {
      return "${m.content} ${trans.kickedBY()} ${m.senderName}";
    }

    return m.content;
  }
}
