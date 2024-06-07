// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FileMessageItem extends StatelessWidget {
  final VFileMessage message;

  const FileMessageItem({
    super.key,
    required this.message,
  });

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
              title: Text(
                message.data.fileSource.name,
                style: message.isMeSender
                    ? context.vMessageTheme.senderTextStyle
                        .copyWith(fontSize: 14)
                    : context.vMessageTheme.receiverTextStyle
                        .copyWith(fontSize: 14),
              ),
              subtitle: Text(
                message.data.fileSource.readableSize,
                style: message.isMeSender
                    ? context.vMessageTheme.senderTextStyle
                        .copyWith(fontSize: 14)
                    : context.vMessageTheme.receiverTextStyle
                        .copyWith(fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }
}
