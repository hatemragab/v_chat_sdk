// import 'package:flutter/material.dart';
// import 'package:flutter_parsed_text/flutter_parsed_text.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ParsedTextMessage extends StatelessWidget {
//   final String message;
//   final bool disableTaps;
//   final int? maxLines;
//   final TextStyle textStyle;
//
//   const ParsedTextMessage({
//     super.key,
//     required this.message,
//     required this.disableTaps,
//     this.maxLines,
//     required this.textStyle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final blueTheme = textStyle.copyWith(color: Colors.blue);
//     return ParsedText(
//       text: message,
//       maxLines: maxLines,
//       style: textStyle,
//       parse: [
//         MatchText(
//           pattern: r"\[(@[^:]+):([^\]]+)\]",
//           style: blueTheme,
//           renderText: ({required String str, required String pattern}) {
//             final map = <String, String>{};
//             final RegExp customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
//             final match = customRegExp.firstMatch(str);
//             map['display'] = match!.group(1)!;
//             return map;
//           },
//           onTap: disableTaps
//               ? null
//               : (url) {
//                   final customRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");
//                   final match = customRegExp.firstMatch(url)!;
//                   //todo add mention clicked callback
//                   //Get.toNamed(Routes.PEER_PAGE, arguments: match.group(2));
//                 },
//         ),
//         MatchText(
//           type: ParsedType.EMAIL,
//           style: blueTheme,
//           onTap: (url) {
//             lunch(url);
//           },
//         ),
//         MatchText(
//           type: ParsedType.URL,
//           style: blueTheme,
//           onTap: disableTaps
//               ? null
//               : (url) {
//                   String fullUrl = url;
//                   if (!fullUrl.contains("https") || !fullUrl.contains("http")) {
//                     fullUrl = "https://$url";
//                   }
//                   lunch(fullUrl);
//                 },
//         ),
//         MatchText(
//           type: ParsedType.PHONE,
//           style: blueTheme,
//           onTap: disableTaps
//               ? null
//               : (url) {
//                   lunch(
//                     url,
//                   );
//                 },
//         ),
//       ],
//     );
//   }
//
//   void lunch(String value) {
//     launchUrl(
//       Uri.parse(value.trim()),
//       mode: LaunchMode.externalApplication,
//     );
//   }
// }
