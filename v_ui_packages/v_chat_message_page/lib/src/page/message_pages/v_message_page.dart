// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_message_page.dart';

class VMessagePage extends StatelessWidget {
  final VRoom vRoom;

  const VMessagePage({
    Key? key,
    required this.vRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetTheme = VInheritedMessageTheme.of(context);
    return VInheritedMessageTheme(
      theme: widgetTheme == null
          ? context.isDark
              ? VDarkMessageTheme()
              : VLightMessageTheme()
          : widgetTheme.theme,
      child: _child(context),
    );
  }

  Widget _child(BuildContext context) {
    switch (vRoom.roomType) {
      case VRoomType.s:
        return VSingleView(
          vRoom: vRoom,
          context: context,
        );
      case VRoomType.g:
        return VGroupView(
          vRoom: vRoom,
          context: context,
        );
      case VRoomType.b:
        return VBroadcastView(
          vRoom: vRoom,
          context: context,
        );
      case VRoomType.o:
        return VOrderView(
          vRoom: vRoom,
          context: context,
        );
    }
  }
}
