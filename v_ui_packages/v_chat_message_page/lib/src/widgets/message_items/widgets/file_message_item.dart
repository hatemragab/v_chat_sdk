// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class FileMessageItem extends StatelessWidget {
  final VFileMessage message;

  const FileMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            PhosphorIcons.fileArrowDown,
            size: 40,
          ),
          Expanded(
            child: ListTile(
              // visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: message.data.fileSource.name.text
                  .styled(
                    style: message.isMeSender
                        ? context.vMessageTheme.senderTextStyle
                        : context.vMessageTheme.receiverTextStyle,
                  )
                  .size(14),
              subtitle: message.data.fileSource.readableSize.text
                  .styled(
                    style: message.isMeSender
                        ? context.vMessageTheme.senderTextStyle
                        : context.vMessageTheme.receiverTextStyle,
                  )
                  .size(14),
            ),
          )
        ],
      ),
    );
  }
}
