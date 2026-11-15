// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_message_page/src/v_chat/string_utils.dart';

void main() {
  test('message mentions preserve display names', () {
    const value = '[@Hatem:user-1] sent a message';

    expect(VStringUtils.parseVMentions(value), '@Hatem sent a message');
    expect(
      VStringUtils.parseVMentions(value, withOutAt: true),
      'Hatem sent a message',
    );
  });
}
