// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'enums.dart';

class VCallerState {
  Duration time;
  CallStatus status;

  VCallerState({
    this.time = Duration.zero,
    this.status = CallStatus.connecting,
  });

  @override
  String toString() {
    return '{time: $time, status: $status}';
  }
}
