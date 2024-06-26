// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/v_chat/platform_cache_image_widget.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/types.dart';

class ReplyItemWidget extends StatelessWidget {
  final VBaseMessage? rToMessage;
  final VMessageCallback? onHighlightMessage;
  final bool isMeSender;
  final String repliedToYourSelf;

  const ReplyItemWidget({
    super.key,
    required this.rToMessage,
    required this.onHighlightMessage,
    required this.isMeSender,
    required this.repliedToYourSelf,
  });

  @override
  Widget build(BuildContext context) {
    if (rToMessage == null) {
      return const SizedBox.shrink();
    }
    final method =
        context.vMessageTheme.vMessageItemTheme.replyMessageItemBuilder;
    if (method != null) {
      return method(context, isMeSender, rToMessage!);
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
                      Text(
                        getTitle(context),
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text(
                        rToMessage!.realContentMentionParsedWithAt,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
      return repliedToYourSelf;
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
