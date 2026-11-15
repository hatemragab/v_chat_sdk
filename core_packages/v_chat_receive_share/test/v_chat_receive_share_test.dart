// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_receive_share/v_chat_receive_share.dart';

void main() {
  test('exports the share handler initialization entrypoint', () {
    expect(vInitReceiveShareHandler, isA<Future<void> Function()>());
  });
}
