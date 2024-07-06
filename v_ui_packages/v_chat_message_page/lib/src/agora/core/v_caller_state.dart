// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../v_chat_message_page.dart';

class VRtcState {
  Duration time;
  CallStatus status;
  VAgoraConnect? agoraConnect;
  VRtcState({
    this.time = Duration.zero,
    this.status = CallStatus.connecting,
  });

  @override
  String toString() {
    return '{time: $time, status: $status}';
  }
}
