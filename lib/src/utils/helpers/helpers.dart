import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../enums/message_type.dart';
import '../vchat_constants.dart';

class Helpers {
  static String baseName(String path) {
    return basename(path);
  }

  static void vlog(String err) {
    if (enableLog) {
      log("V_CHAT_SDK SAY =>>> $err", name: "V_CHAT_SDK");
    }
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
    return t != MessageType.text &&
        t != MessageType.info &&
        t != MessageType.allDeleted;
  }
}
