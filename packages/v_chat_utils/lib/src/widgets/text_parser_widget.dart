import 'package:flutter/material.dart';

class VTextParserWidget extends StatelessWidget {
  final bool parseEmail;
  final bool parseMentions;
  final bool parsePhone;
  final bool parseLinks;
  final bool enableTabs;
  final String text;
  final int? maxLines;
  final TextStyle? style;
  final Function(String)? onMentionClicked;

  const VTextParserWidget({
    Key? key,
    this.parseEmail = false,
    this.parseMentions = false,
    this.parsePhone = false,
    this.parseLinks = false,
    this.enableTabs = true,
    this.maxLines,
    this.onMentionClicked,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enableTabs,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        //style.merge(other)
        style: style,
      ),
    );
  }
}
