// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';

void main() {
  test('English room language exposes core room labels', () {
    final language = VRoomLanguage.fromEnglish();

    expect(language.yesterdayLabel, 'Yesterday');
    expect(language.typing, 'Typing...');
    expect(language.recording, 'Recording');
  });
}
