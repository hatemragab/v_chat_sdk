// import 'package:build_context/build_context.dart';
// import 'package:flutter/material.dart';
// import 'package:textless/textless.dart';
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
//
// import '../../../../core/platfrom_widgets/platform_cache_image_widget.dart';
// import '../../../../core/widgets/parsed_text_message.dart';
//
// class ReplyWidget extends StatelessWidget {
//   final VBaseMessage? replyMessage;
//   final VoidCallback onDismissReply;
//
//   const ReplyWidget({
//     super.key,
//     required this.replyMessage,
//     required this.onDismissReply,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (replyMessage == null) {
//       throw "cant reply to null message !";
//     }
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       decoration: BoxDecoration(
//         color: context.platformBrightness == Brightness.dark
//             ? Colors.black54
//             : Colors.grey[200],
//         borderRadius: const BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 8, left: 4),
//                 child: replyMessage!.senderName.cap,
//               ),
//               Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   if (replyMessage!.isImage)
//                     PlatformCacheImageWidget(
//                       source: (replyMessage! as VImageMessage)
//                           .fileSource
//                           .fileSource,
//                       size: const Size(50, 50),
//                     ),
//                   InkWell(
//                     onTap: onDismissReply,
//                     child: Container(
//                       margin: const EdgeInsets.all(3),
//                       padding: const EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.clear,
//                         size: 12,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
//               child: ParsedTextMessage(
//                 maxLines: 2,
//                 disableTaps: true,
//                 message: replyMessage!.getTextTrans,
//                 textStyle: Theme.of(context).textTheme.bodySmall!,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
