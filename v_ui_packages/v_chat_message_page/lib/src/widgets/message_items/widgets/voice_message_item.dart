// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/core/extension.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VoiceMessageItem extends StatelessWidget {
  final VVoiceMessage message;
  final VVoiceMessageController? Function(VBaseMessage message) voiceController;

  const VoiceMessageItem({
    super.key,
    required this.message,
    required this.voiceController,
  });

  @override
  Widget build(BuildContext context) {
    //   print(message.data.fileSource.url);
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      padding: const EdgeInsets.all(10),
      child: VVoiceMessageView(
        controller: voiceController(message)!,
        notActiveSliderColor: context
            .getMessageItemHolderColor(
              message.isMeSender,
              context,
            )
            .withOpacity(.3),
        activeSliderColor: context.isDark ? Colors.green : Colors.red,
      ),
    );
  }
}
