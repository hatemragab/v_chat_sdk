// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../../../v_chat_message_page.dart';

class TextMessageItem extends StatelessWidget {
  final String message;
  final TextStyle textStyle;
  final Function(String email) onEmailPress;
  final Function(BuildContext context, String userId) onMentionPress;
  final Function(String phone) onPhonePress;
  final Function(String link) onLinkPress;

  const TextMessageItem({
    Key? key,
    required this.message,
    required this.textStyle,
    required this.onEmailPress,
    required this.onMentionPress,
    required this.onPhonePress,
    required this.onLinkPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return CustomCard(
    //   msg: message,
    //   timeTextWidget: Row(
    //     children: [
    //       MessageTimeWidget(
    //         dateTime: DateTime.now(),
    //       ),
    //       const MessageStatusIcon(
    //         model: MessageStatusIconDataModel(
    //             isMeSender: true,
    //             isSeen: false,
    //             isDeliver: false,
    //             emitStatus: VMessageEmitStatus.serverConfirm
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return VTextParserWidget(
      text: message,
      textStyle: textStyle,
      enableTabs: true,
      onEmailPress: onEmailPress,
      onLinkPress: onLinkPress,
      onPhonePress: onPhonePress,
      onMentionPress: (userId) => onMentionPress(context, userId),
    );
  }
}
