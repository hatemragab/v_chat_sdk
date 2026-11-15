// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_sdk_sample/app/v_chat/string_utils.dart';

void main() {
  test('sample duration formatting remains stable', () {
    expect(
      VStringUtils.printDuration(const Duration(minutes: 9, seconds: 7)),
      '09:07',
    );
  });

  test('sample user model round-trips through a map', () {
    final user = UserModel(
      id: 'user-1',
      fullName: 'Hatem Ragab',
      imageUrl: 'https://example.com/avatar.png',
    );

    expect(UserModel.fromMap(user.toMap()), user);
  });
}
