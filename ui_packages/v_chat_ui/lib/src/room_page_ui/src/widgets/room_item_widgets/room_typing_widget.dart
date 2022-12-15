import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class RoomTypingWidget extends StatelessWidget {
  final String text;
  const RoomTypingWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return text.text.color(Colors.green);
  }
}
