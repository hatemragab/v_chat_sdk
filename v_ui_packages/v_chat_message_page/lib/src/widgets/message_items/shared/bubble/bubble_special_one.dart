// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'package:flutter/material.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
//
// ///WhatsApp's chat bubble type
// ///
// ///chat bubble color can be customized using [color]
// ///chat bubble tail can be customized  using [tail]
// ///chat bubble display message can be changed using [title]
// ///[title] is the only required parameter
// ///message sender can be changed using [isSender]
// ///chat bubble [TextStyle] can be customized using [textStyle]
// class BubbleSpecialOne extends StatelessWidget {
//   final bool isSender;
//   final Widget child;
//   final bool tail;
//   final bool isRtl;
//   final Color color;
//
//   const BubbleSpecialOne({
//     Key? key,
//     this.isSender = true,
//     required this.child,
//     required this.isRtl,
//     this.color = Colors.white70,
//     this.tail = true,
//   }) : super(key: key);
//
//   ///chat bubble builder method
//   @override
//   Widget build(BuildContext context) {
//     bool isHaveTail = tail;
//     var alignment = AlignmentDirectional.topStart;
//     if (isSender) {
//       alignment = AlignmentDirectional.centerEnd;
//     } else {
//       alignment = AlignmentDirectional.centerStart;
//     }
//     if (isRtl) {
//       isHaveTail = false;
//     }
//
//     return Align(
//       alignment: alignment,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//         child: CustomPaint(
//           painter: SpecialChatBubbleOne(
//             color: color,
//             alignmentDirectional: alignment,
//             tail: isHaveTail,
//           ),
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: VPlatforms.isMobile
//                   ? MediaQuery.of(context).size.width * .75
//                   : MediaQuery.of(context).size.width * .55,
//             ),
//             margin: isSender
//                 ? const EdgeInsets.fromLTRB(4, 7, 14, 2)
//                 : const EdgeInsets.fromLTRB(14, 7, 6, 2),
//             // margin: isSender
//             //     ? stateTick
//             //         ? const EdgeInsets.fromLTRB(7, 7, 14, 7)
//             //         : const EdgeInsets.fromLTRB(7, 7, 17, 7)
//             //     : const EdgeInsets.fromLTRB(17, 7, 7, 7),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// ///custom painter use to create the shape of the chat bubble
// ///
// /// [color],[alignment] and [tail] can be changed
// class SpecialChatBubbleOne extends CustomPainter {
//   final Color color;
//   final AlignmentDirectional alignmentDirectional;
//   final bool tail;
//
//   SpecialChatBubbleOne({
//     required this.color,
//     required this.alignmentDirectional,
//     required this.tail,
//   });
//
//   final double _radius = 10.0;
//   final double _x = 10.0;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (alignmentDirectional == AlignmentDirectional.centerEnd) {
//       if (tail) {
//         canvas.drawRRect(
//             RRect.fromLTRBAndCorners(
//               0,
//               0,
//               size.width - _x,
//               size.height,
//               bottomLeft: Radius.circular(_radius),
//               bottomRight: Radius.circular(_radius),
//               topLeft: Radius.circular(_radius),
//             ),
//             Paint()
//               ..color = color
//               ..style = PaintingStyle.fill);
//         var path = Path();
//         path.moveTo(size.width - _x, 0);
//         path.lineTo(size.width - _x, 10);
//         path.lineTo(size.width, 0);
//         canvas.clipPath(path);
//         canvas.drawRRect(
//             RRect.fromLTRBAndCorners(
//               size.width - _x,
//               0.0,
//               size.width,
//               size.height,
//               topRight: const Radius.circular(3),
//             ),
//             Paint()
//               ..color = color
//               ..style = PaintingStyle.fill);
//       } else {
//         canvas.drawRRect(
//           RRect.fromLTRBAndCorners(
//             0,
//             0,
//             size.width - _x,
//             size.height,
//             bottomLeft: Radius.circular(_radius),
//             bottomRight: Radius.circular(_radius),
//             topLeft: Radius.circular(_radius),
//             topRight: Radius.circular(_radius),
//           ),
//           Paint()
//             ..color = color
//             ..style = PaintingStyle.fill,
//         );
//       }
//     } else {
//       if (tail) {
//         canvas.drawRRect(
//             RRect.fromLTRBAndCorners(
//               _x,
//               0,
//               size.width,
//               size.height,
//               bottomRight: Radius.circular(_radius),
//               topRight: Radius.circular(_radius),
//               bottomLeft: Radius.circular(_radius),
//             ),
//             Paint()
//               ..color = color
//               ..style = PaintingStyle.fill);
//         var path = Path();
//         path.moveTo(_x, 0);
//         path.lineTo(_x, 10);
//         path.lineTo(0, 0);
//         canvas.clipPath(path);
//         canvas.drawRRect(
//           RRect.fromLTRBAndCorners(
//             0,
//             0.0,
//             _x,
//             size.height,
//             topLeft: const Radius.circular(3),
//           ),
//           Paint()
//             ..color = color
//             ..style = PaintingStyle.fill,
//         );
//       } else {
//         canvas.drawRRect(
//           RRect.fromLTRBAndCorners(
//             _x,
//             0,
//             size.width,
//             size.height,
//             bottomRight: Radius.circular(_radius),
//             topRight: Radius.circular(_radius),
//             bottomLeft: Radius.circular(_radius),
//             topLeft: Radius.circular(_radius),
//           ),
//           Paint()
//             ..color = color
//             ..style = PaintingStyle.fill,
//         );
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
