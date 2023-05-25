// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

abstract class VChatLogger {
  static String name = "V_CHAT_SDK_V2";

  static void red(String text) {
    if (kDebugMode) {
      print(
        '\x1B[31m$text\x1B[0m',
      );
    }
  }

  static void green(String text) {
    if (kDebugMode) {
      print(
        '\x1B[32m$text\x1B[0m',
      );
    }
  }

  static void yellow(String text) {
    if (kDebugMode) {
      print(
        '\x1B[33m$text\x1B[0m',
      );
    }
  }

  static void blue(String text) {
    if (kDebugMode) {
      print(
        '\x1B[34m$text\x1B[0m',
      );
    }
  }
}
