import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ChatLastMsgTime extends StatelessWidget {
  final String lastMessageTimeString;
  const ChatLastMsgTime({
    Key? key,
    required this.lastMessageTimeString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return lastMessageTimeString.cap;
  }
}
