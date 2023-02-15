// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

class VRtcAppLog {
  final String title;
  final String desc;

  const VRtcAppLog({
    required this.title,
    required this.desc,
  });
}

final vRtcLoggerStream = StreamController<VRtcAppLog>.broadcast();
