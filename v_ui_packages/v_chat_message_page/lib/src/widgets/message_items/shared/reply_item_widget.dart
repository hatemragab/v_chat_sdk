// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../core/types.dart';

class ReplyItemWidget extends StatelessWidget {
  final VBaseMessage? rToMessage;
  final VMessageCallback? onHighlightMessage;
  final bool isMeSender;

  const ReplyItemWidget({
    Key? key,
    required this.rToMessage,
    required this.onHighlightMessage,
    required this.isMeSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rToMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: isMeSender
            ? context.vMessageTheme.senderBubbleColor.withOpacity(.4)
            : context.vMessageTheme.receiverBubbleColor.withOpacity(.4),
        // color: context.isDark
        //     ? Colors.blue.withOpacity(.2)
        //     : const Color(0xffe7d8d8).withOpacity(.5),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(15),
        ),
      ),
      child: InkWell(
        onLongPress: null,
        onTap: onHighlightMessage == null
            ? null
            : () => onHighlightMessage!(rToMessage!),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalDivider(
                  color: isMeSender
                      ? context.vMessageTheme.senderBubbleColor
                      : context.vMessageTheme.receiverBubbleColor,
                  thickness: 3,
                  width: 2,
                  indent: 2,
                ),
                const SizedBox(
                  width: 9,
                ),
                // const Icon(
                //   Icons.reply,
                //   color: Colors.green,
                //   size: 15,
                // ),
                const SizedBox(width: 2),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTitle(context).text.color(Colors.green),
                      rToMessage!.realContentMentionParsedWithAt.cap
                          .maxLine(2)
                          .overflowEllipsis,
                    ],
                  ),
                ),
                _getImage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(BuildContext context) {
    if (rToMessage!.isMeSender) {
      return VTrans.labelsOf(context).repliedToYourSelf;
    }
    return rToMessage!.senderName;
  }

  Widget _getImage() {
    if (rToMessage! is VImageMessage) {
      final msg = rToMessage! as VImageMessage;
      return VPlatformCacheImageWidget(
        source: msg.data.fileSource,
        borderRadius: BorderRadius.circular(9),
        size: const Size(40, 40),
      );
    }
    return const SizedBox.shrink();
  }
}
