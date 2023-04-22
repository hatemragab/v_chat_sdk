// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class AllDeletedItem extends StatelessWidget {
  final VBaseMessage message;

  const AllDeletedItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        VTrans.of(context).labels.messageHasBeenDeleted,
        style: message.isMeSender
            ? context.vMessageTheme.senderTextStyle
                .merge(const TextStyle(fontStyle: FontStyle.italic))
            : context.vMessageTheme.receiverTextStyle
                .merge(const TextStyle(fontStyle: FontStyle.italic)),
      ),
    );
  }
}
