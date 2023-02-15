// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_input_ui/src/models/v_input_theme.dart';

class MessageSendBtn extends StatelessWidget {
  final VoidCallback onSend;

  const MessageSendBtn({
    super.key,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSend,
      child: context.vInputTheme.sendBtn,
    );
  }
}
