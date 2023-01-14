import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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
    final isRtl = context.isRtl;
    return context.vMessageTheme.vMessageItemBuilder.messageBubble(
      context,
      isMeSender,
      child,
    );

    // return BubbleSpecialOne(
    //   isSender: isMeSender,
    //   isRtl: isRtl,
    //   tail: true,
    //   color: context.vMessageTheme.vMessageItemBuilder.holderColor(
    //     isMeSender,
    //   ),
    //   child: child,
    // );
  }
}
