import 'package:flutter/material.dart';

class TextParserWidget extends StatelessWidget {
  final bool parseEmail;
  final bool parseMentions;
  final bool parsePhone;
  final bool parseLinks;
  final bool? enableTabs;
  final String text;
  final int? maxLines;
  final TextStyle? style;

  const TextParserWidget({
    Key? key,
    this.parseEmail = false,
    this.parseMentions = false,
    this.parsePhone = false,
    this.parseLinks = false,
    this.enableTabs = true,
    this.maxLines,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      //style.merge(other)
      style: style,
    );
  }
}
