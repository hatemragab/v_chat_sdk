// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_utils/src/utils/string_utils.dart';

void main() {
  testMention();
}

void testMention() {
  var message = "test [@user 2:2222222222] test2 [@user 3:333333333]";
  final x = message.replaceAllMapped(
    VStringUtils.vMentionRegExp,
    (match) {
      final matchTxt = match.group(1)!;
      return matchTxt;
    },
  );
  print(x);
}
