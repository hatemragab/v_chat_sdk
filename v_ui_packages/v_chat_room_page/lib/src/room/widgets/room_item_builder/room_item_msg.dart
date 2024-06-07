// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';
import 'package:v_chat_room_page/src/room/shared/v_message_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// A widget that displays a message in a chat room item. /// /// The [message] parameter is the message to be displayed. /// The [isBold] parameter determines if the message should be displayed in bold text. class RoomItemMsg extends StatelessWidget { final bool isBold; final VBaseMessage message;
/// A widget that displays a message in a chat room item. /// /// The [message] parameter is the message to be displayed. /// The [isBold] parameter determines if the message should be displayed in bold text. class RoomItemMsg extends StatelessWidget { final bool isBold; final VBaseMessage message;const RoomItemMsg({ Key? key, required this.message, required this.isBold, }) : super(key: key); }
class RoomItemMsg extends StatelessWidget {
  /// The message to be displayed.
  final bool isBold;
  final String messageHasBeenDeletedLabel;

  /// Determines if the message should be displayed in bold text.
  final VBaseMessage message;
  final VMessageInfoTrans language;

  /// Creates a [RoomItemMsg] widget.
  const RoomItemMsg({
    super.key,
    required this.message,
    required this.isBold,
    required this.language,
    required this.messageHasBeenDeletedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.vRoomTheme;
    if (message.allDeletedAt != null) {
      return Text(
        messageHasBeenDeletedLabel,
        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      );
    }
    if (message.isDeleted) {
      return Text(
        VMessageConstants.getMessageBody(message, language),
        style: const TextStyle(
          decoration: TextDecoration.lineThrough,
        ),
      );
    }
    if (isBold) {
      return VTextParserWidget(
        text: VMessageConstants.getMessageBody(message, language),
        enableTabs: false,
        isOneLine: true,
        textStyle: theme.unSeenLastMessageTextStyle,
      );
    }
    return VTextParserWidget(
      text: VMessageConstants.getMessageBody(message, language),
      enableTabs: false,
      isOneLine: true,
      textStyle: theme.seenLastMessageTextStyle,
    );
  }
}
