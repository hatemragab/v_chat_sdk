import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../core/types.dart';

class ReplyItemWidget extends StatelessWidget {
  final VBaseMessage? rToMessage;
  final VMessageCallback? onHighlightMessage;

  const ReplyItemWidget({
    Key? key,
    required this.rToMessage,
    required this.onHighlightMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rToMessage == null) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.isDark ? Colors.black38 : const Color(0xffe7d8d8),
        borderRadius: BorderRadius.circular(7),
      ),
      child: InkWell(
        onTap: onHighlightMessage == null
            ? null
            : () => onHighlightMessage!(rToMessage!),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.reply,
              color: Colors.green,
              size: 15,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
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
