// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';

class AgoraUser {
  final int uid;
  String? name;
  bool? isAudioEnabled;
  bool? isVideoEnabled;
  Widget? view;

  AgoraUser({
    required this.uid,
    this.name,
    this.isAudioEnabled,
    this.isVideoEnabled,
    this.view,
  });
}
