// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../shared/theme/v_msg_status_theme.dart';

class MessageStatusIconDataModel {
  final bool isMeSender;
  final bool isSeen;
  final bool isDeliver;
  final bool isAllDeleted;
  final VMessageEmitStatus emitStatus;

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
