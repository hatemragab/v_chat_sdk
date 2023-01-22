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
    return VTextParserWidget(
      text: message,
      maxLines: 5,
      textStyle: textStyle,
      enableTabs: true,
      onEmailPress: onEmailPress,
      onLinkPress: onLinkPress,
      onPhonePress: onPhonePress,
      onMentionPress: (userId) => onMentionPress(context, userId),
    );
  }
}