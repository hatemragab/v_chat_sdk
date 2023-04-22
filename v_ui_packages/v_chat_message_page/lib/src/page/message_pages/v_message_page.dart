// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../v_chat_message_page.dart';

class VMessagePage extends StatelessWidget {
  final VRoom vRoom;
  final VMessageConfig vMessageConfig;

  const VMessagePage({
    Key? key,
    required this.vRoom,
    this.vMessageConfig = const VMessageConfig(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _child(context);
  }

  Widget _child(BuildContext context) {
    switch (vRoom.roomType) {
      case VRoomType.s:
        return VSingleView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
        );
      case VRoomType.g:
        return VGroupView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
        );
      case VRoomType.b:
        return VBroadcastView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
        );
      case VRoomType.o:
        return VOrderView(
          vMessageConfig: vMessageConfig,
          vRoom: vRoom,
        );
    }
  }
}
