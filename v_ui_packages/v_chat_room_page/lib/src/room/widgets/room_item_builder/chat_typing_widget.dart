import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ChatTypingWidget extends StatelessWidget {
  final String text;
  const ChatTypingWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return text.text.color(Colors.green);
  }
}
