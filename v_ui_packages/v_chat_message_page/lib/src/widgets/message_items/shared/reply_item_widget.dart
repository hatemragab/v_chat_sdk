import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../core/types.dart';

class ReplyItemWidget extends StatelessWidget {
  final VBaseMessage? rToMessage;
  final VMessageCallback onHighlightMessage;

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
        color: Colors.black26,
        borderRadius: BorderRadius.circular(7),
      ),
      child: InkWell(
        onTap: () => onHighlightMessage(rToMessage!),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.reply,
              size: 15,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitle().text,
                  rToMessage!.getTextTrans.cap.maxLine(2).overflowEllipsis,
                ],
              ),
            ),
            _getImage()
          ],
        ),
      ),
    );
  }

  String getTitle() {
    if (rToMessage!.isMeSender) {
      //todo trans
      return "replied to your self";
    }
    return rToMessage!.senderName;
  }

  Widget _getImage() {
    if (rToMessage! is VImageMessage) {
      final msg = rToMessage! as VImageMessage;
      return VPlatformCacheImageWidget(
        source: msg.data.fileSource,
        borderRadius: BorderRadius.circular(9),
        size: Size(40, 40),
      );
    }
    return const SizedBox.shrink();
  }
}
