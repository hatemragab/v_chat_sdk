// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

extension VSortRoomByMsgId on List<VRoom> {
  List<VRoom> sortByMsgId() {
    sort((a, b) {
      return b.lastMessage.id.compareTo(a.lastMessage.id);
    });
    return this;
  }
}
