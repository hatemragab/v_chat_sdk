import 'package:flutter/material.dart';

class TextParserWidget extends StatelessWidget {
  final bool parseEmail;
  final bool parseMentions;
  final bool parsePhone;
  final bool parseLinks;
  final String text;

  const TextParserWidget({
    Key? key,
    this.parseEmail = false,
    this.parseMentions = false,
    this.parsePhone = false,
    this.parseLinks = false,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
