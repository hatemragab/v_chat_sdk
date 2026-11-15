// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_sdk_core/src/utils/string_utils.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

void main() {
  group('VStringUtils', () {
    test('parses mentions with and without the at sign', () {
      const value = 'Hello [@Hatem:user-1]';

      expect(VStringUtils.parseVMentions(value), 'Hello @Hatem');
      expect(
        VStringUtils.parseVMentions(value, withOutAt: true),
        'Hello Hatem',
      );
    });

    test('formats durations as minutes and seconds', () {
      expect(VStringUtils.printDuration(const Duration(seconds: 125)), '02:05');
    });
  });

  test('VBaseFilter round-trips through a map', () {
    final filter = VBaseFilter(limit: 20, page: 3, name: 'hatem');

    expect(VBaseFilter.fromMap(filter.toMap()), filter);
  });
}
