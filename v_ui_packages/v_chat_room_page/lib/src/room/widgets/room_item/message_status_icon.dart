// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../shared/theme/v_msg_status_theme.dart';

/// Data model class for message status icons. /// /// Contains properties such as whether the message was sent by the current user (isMeSender), /// whether the message has been seen (isSeen), whether the message has been delivered (isDeliver), /// whether all copies of the message have been deleted (isAllDeleted), and the current emit status (emitStatus). class MessageStatusIconDataModel { final bool isMeSender; final bool isSeen; final bool isDeliver; final bool isAllDeleted; final VMessageEmitStatus emitStatus;
/// Constructs a new instance of [MessageStatusIconDataModel]. /// /// [isMeSender] - Whether the message was sent by the current user. /// [isSeen] - Whether the message has been seen. /// [isDeliver] - Whether the message has been delivered. /// [isAllDeleted] - Whether all copies of the message have been deleted. Default value is false. /// [emitStatus] - The current emit status of the message. const MessageStatusIconDataModel({ required this.isMeSender, required this.isSeen, required this.isDeliver, this.isAllDeleted = false, required this.emitStatus, }); }
class MessageStatusIconDataModel {
  /// Whether the message was sent by the current user.
  final bool isMeSender;

  /// Whether the message has been seen.
  final bool isSeen;

  /// Whether the message has been delivered.
  final bool isDeliver;

  /// Whether all copies of the message have been deleted. Default value is false.
  final bool isAllDeleted;

  /// The current emit status of the message.
  final VMessageEmitStatus emitStatus;

  /// Constructs a new instance of [MessageStatusIconDataModel].
  const MessageStatusIconDataModel({
    required this.isMeSender,
    required this.isSeen,
    required this.isDeliver,
    this.isAllDeleted = false,
    required this.emitStatus,
  });
}

class MessageStatusIcon extends StatelessWidget {
  final VoidCallback? onReSend;
  final MessageStatusIconDataModel model;

  const MessageStatusIcon({
    Key? key,
    required this.model,
    this.onReSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = context.vRoomTheme.lastMessageStatus;
    if (!model.isMeSender || model.isAllDeleted) {
      return const SizedBox.shrink();
    }
    if (model.isSeen) {
      return _getBody(themeData.seenIcon);
    }
    if (model.isDeliver) {
      return _getBody(themeData.deliverIcon);
    }
    return _getBody(
      _getIcon(themeData),
    );
  }

  Widget _getBody(Widget icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: icon,
    );
  }

  Widget _getIcon(VMsgStatusTheme themeData) {
    switch (model.emitStatus) {
      case VMessageEmitStatus.serverConfirm:
        return themeData.sendIcon;
      case VMessageEmitStatus.error:
        return InkWell(
          onTap: () {
            if (onReSend != null) {
              onReSend!();
            }
          },
          child: themeData.refreshIcon,
        );
      case VMessageEmitStatus.sending:
        return themeData.pendingIcon;
    }
  }
}
