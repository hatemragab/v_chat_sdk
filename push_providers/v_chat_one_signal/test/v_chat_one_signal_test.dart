// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_one_signal/v_chat_one_signal.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

void main() {
  test('reports OneSignal as its push service', () {
    final provider = VChatOneSignalProver(appId: 'test-app-id');

    expect(provider.serviceName(), VChatPushService.onesignal);
  });
}
