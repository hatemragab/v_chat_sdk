import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';

class DirectionItemHolder extends StatelessWidget {
  final Widget child;
  final bool isMeSender;

  const DirectionItemHolder({
    Key? key,
    required this.child,
    required this.isMeSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.vMessageTheme.messageItemHolder(
      context,
      isMeSender,
      child,
    );
  }
}
