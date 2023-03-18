// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class RoomItemMsg extends StatelessWidget {
  final bool isBold;
  final VBaseMessage message;

  const RoomItemMsg({
    Key? key,
    required this.message,
    required this.isBold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.vRoomTheme;
    if (message.allDeletedAt != null) {
      return VTrans.of(context)
          .labels
          .messageHasBeenDeleted
          .text
          .italic
          .color(Colors.grey);
    }
    if (message.isDeleted) {
      return message.getMessageTextInfoTranslated(context).text.lineThrough;
    }
    if (isBold) {
      return VTextParserWidget(
        text: message.getMessageTextInfoTranslated(context),
        enableTabs: false,
        isOneLine: true,
        textStyle: theme.unSeenLastMessageTextStyle,
      );
    }
    return VTextParserWidget(
      text: message.getMessageTextInfoTranslated(context),
      enableTabs: false,
      isOneLine: true,
      textStyle: theme.seenLastMessageTextStyle,
    );
  }
}
