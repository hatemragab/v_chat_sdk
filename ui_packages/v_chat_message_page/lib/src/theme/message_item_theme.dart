import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VMessageItemBuilder {
  VMessageItemBuilder._({
    required this.directionalItemDecoration,
    required this.directionalItemConstraints,
    required this.messageSendingStatus,
    required this.holderColor,
  });

  final BoxDecoration directionalItemDecoration;
  final BoxConstraints Function(BuildContext) directionalItemConstraints;
  final Color Function(bool isMeSender) holderColor;
  final VMsgStatusTheme messageSendingStatus;

  factory VMessageItemBuilder.light() {
    return VMessageItemBuilder._(
      directionalItemDecoration: const BoxDecoration(),
      holderColor: (isMeSender) =>
          isMeSender ? const Color(0xff96f3aa) : const Color(0xff1eaea),
      messageSendingStatus: const VMsgStatusTheme.light(),
      directionalItemConstraints: (context) => BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .80,
        maxHeight: MediaQuery.of(context).size.height * .40,
      ),
    );
  }

  factory VMessageItemBuilder.dark() {
    return VMessageItemBuilder._(
      messageSendingStatus: const VMsgStatusTheme.dark(),
      holderColor: (isMeSender) => isMeSender ? Colors.indigo : Colors.black26,
      directionalItemDecoration: const BoxDecoration(color: Colors.green),
      directionalItemConstraints: (context) => BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .80,
        maxHeight: MediaQuery.of(context).size.height * .40,
      ),
    );
  }
}
