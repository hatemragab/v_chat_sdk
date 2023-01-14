import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../v_chat_message_page.dart';
import '../widgets/message_items/shared/bubble_special_one.dart';

class VMessageItemBuilder {
  VMessageItemBuilder._({
    required this.directionalItemDecoration,
    required this.directionalItemConstraints,
    required this.messageSendingStatus,
    //required this.holderColor,
    required this.messageBubble,
  });

  final BoxDecoration directionalItemDecoration;
  final BoxConstraints Function(BuildContext) directionalItemConstraints;
  final Widget Function(
    BuildContext context,
    bool isMeSender,
    Widget child,
  ) messageBubble;
  // final Color Function(bool isMeSender) holderColor;
  final VMsgStatusTheme messageSendingStatus;

  factory VMessageItemBuilder.light() {
    return VMessageItemBuilder._(
      directionalItemDecoration: const BoxDecoration(),
      // holderColor: (isMeSender) =>
      //     isMeSender ? const Color(0xff96f3aa) : const Color(0x0ff1eaea),
      messageSendingStatus: const VMsgStatusTheme.light(),
      messageBubble: (context, isMeSender, child) {
        final isRtl = context.isRtl;
        return BubbleSpecialOne(
          isSender: isMeSender,
          isRtl: isRtl,
          tail: true,
          color: isMeSender ? const Color(0xff96f3aa) : const Color(0x0ff1eaea),
          child: child,
        );
      },
      directionalItemConstraints: (context) => BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .80,
        maxHeight: MediaQuery.of(context).size.height * .40,
      ),
    );
  }

  factory VMessageItemBuilder.dark() {
    return VMessageItemBuilder._(
      messageSendingStatus: const VMsgStatusTheme.dark(),
      messageBubble: (context, isMeSender, child) {
        final isRtl = context.isRtl;
        return BubbleSpecialOne(
          isSender: isMeSender,
          isRtl: isRtl,
          tail: true,
          color: isMeSender ? Colors.indigo : const Color(0xff515156),
          child: child,
        );
      },
      // holderColor: (isMeSender) =>
      //     isMeSender ? Colors.indigo :const Color(0xff515156),
      directionalItemDecoration: const BoxDecoration(color: Colors.green),
      directionalItemConstraints: (context) => BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .80,
        maxHeight: MediaQuery.of(context).size.height * .40,
      ),
    );
  }
}
