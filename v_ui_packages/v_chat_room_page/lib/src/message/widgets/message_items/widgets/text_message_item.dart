import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../shared/widgets/text_parser_widget.dart';

class TextMessageItem extends StatelessWidget {
  final VTextMessage message;
  final Function(String email) onEmailPress;
  final Function(BuildContext context, String userId) onMentionPress;
  final Function(String phone) onPhonePress;
  final Function(String link) onLinkPress;

  const TextMessageItem({
    Key? key,
    required this.message,
    required this.onEmailPress,
    required this.onMentionPress,
    required this.onPhonePress,
    required this.onLinkPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VTextParserWidget(
      text: message.getTextTrans,
      maxLines: 5,
      enableTabs: true,
      onEmailPress: onEmailPress,
      onLinkPress: onLinkPress,
      onPhonePress: onPhonePress,
      onMentionPress: (userId) => onMentionPress(context, userId),
    );
  }
}
