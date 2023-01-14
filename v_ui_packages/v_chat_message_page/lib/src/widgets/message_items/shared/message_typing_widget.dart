import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class MessageTypingWidget extends StatelessWidget {
  final String text;
  const MessageTypingWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return text.text.color(Colors.green);
  }
}
