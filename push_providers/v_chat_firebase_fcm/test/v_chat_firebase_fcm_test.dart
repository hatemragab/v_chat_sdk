// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

void main() {
  test('reports Firebase as its push service', () {
    expect(VChatFcmProver().serviceName(), VChatPushService.firebase);
  });
}
