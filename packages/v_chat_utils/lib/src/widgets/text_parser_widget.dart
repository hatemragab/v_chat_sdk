import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

class VTextParserWidget extends StatelessWidget {
  final Function(String email)? onEmailPress;
  final Function(String userId)? onMentionPress;
  final Function(String phone)? onPhonePress;
  final Function(String link)? onLinkPress;
  final bool enableTabs;
  final String text;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextStyle? emailTextStyle;
  final TextStyle? phoneTextStyle;
  final TextStyle? mentionTextStyle;

  const VTextParserWidget({
    Key? key,
    this.onEmailPress,
    this.onMentionPress,
    this.onPhonePress,
    this.onLinkPress,
    this.enableTabs = false,
    this.maxLines,
    required this.text,
    this.textStyle,
    this.emailTextStyle,
    this.phoneTextStyle,
    this.mentionTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const blueTheme = TextStyle(color: Colors.blue);
    return IgnorePointer(
      ignoring: !enableTabs,
      child: ParsedText(
        text: text,
        maxLines: maxLines,
        style: textStyle,
        parse: [
          MatchText(
            pattern: r"\[(@[^:]+):([^\]]+)\]",
            style: blueTheme,
            renderText: ({
              required String str,
              required String pattern,
            }) {
              final map = <String, String>{};
              final RegExp customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
              final match = customRegExp.firstMatch(str);
              map['display'] = match!.group(1)!;
              return map;
            },
            onTap: (url) {
              final customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
              final match = customRegExp.firstMatch(url)!;
              final userId = match.group(2);
              if (onMentionPress != null && userId != null) {
                onMentionPress!(userId);
              }
            },
          ),
          if (onEmailPress != null)
            MatchText(
              type: ParsedType.EMAIL,
              style: blueTheme,
              onTap: (url) {
                onEmailPress!(url);
              },
            ),
          if (onPhonePress != null)
            MatchText(
                type: ParsedType.PHONE,
                style: blueTheme,
                onTap: (url) {
                  onPhonePress!(url);
                }),
          if (onLinkPress != null)
            MatchText(
              type: ParsedType.URL,
              style: blueTheme,
              onTap: (url) {
                String fullUrl = url;
                if (!fullUrl.contains("https") || !fullUrl.contains("http")) {
                  fullUrl = "https://$url";
                }
                onLinkPress!(fullUrl);
              },
            ),
        ],
      ),
    );
  }
}
