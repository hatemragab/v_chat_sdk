// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/v_app_event.dart';

class VSocketIntervalEvent extends VAppEvent {
  @override
  List<Object?> get props => [DateTime.now().microsecondsSinceEpoch];
}
