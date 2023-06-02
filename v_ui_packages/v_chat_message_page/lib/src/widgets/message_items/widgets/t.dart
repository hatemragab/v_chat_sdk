// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'package:flutter/material.dart';
// import 'package:v_chat_message_page/src/core/extension.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
//
// class CustomCard extends StatelessWidget {
//   final String msg;
//   final Widget timeTextWidget;
//
//   const CustomCard({
//     super.key,
//     required this.msg,
//     required this.timeTextWidget,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isTextRtl = Bidi.detectRtlDirectionality(msg);
//     return AutoDirection(
//       text: msg,
//       child: Stack(
//         alignment: Alignment.centerLeft,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8),
//             child: RichText(
//               text: TextSpan(
//                 children: <TextSpan>[
//                   if (isTextRtl)
//                     const TextSpan(
//                       text: "    12:10 AM",
//                       style: TextStyle(
//                         color: Colors.transparent,
//                       ),
//                     ),
//                   //real message
//                   TextSpan(
//                     text: context.isRtl ? msg : "$msg      ",
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//                   if (!isTextRtl)
//                     const TextSpan(
//                       text: "12:10 AM",
//                       style: TextStyle(
//                         color: Colors.transparent,
//                       ),
//                     ),
//                   //fake additionalInfo as placeholder
//                 ],
//               ),
//             ),
//           ),
//
//           //real additionalInfo
//           AutoDirection(
//             text: "hi",
//             child: Positioned(
//               right: 0,
//               bottom: 2,
//               child: timeTextWidget,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
