import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ReplyMsgWidget extends StatelessWidget {
  final VBaseMessage vBaseMessage;
  final VoidCallback onDismiss;

  const ReplyMsgWidget({
    super.key,
    required this.vBaseMessage,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle().text.maxLine(1),
              vBaseMessage.getTextTrans.cap.maxLine(2).overflowEllipsis,
            ],
          ),
        ),
        getImage()
      ],
    );
  }

  String getTitle() {
    if (vBaseMessage.isMeSender) {
      return "Reply to your self";
    }
    return vBaseMessage.senderName;
  }

  Widget getImage() {
    if (vBaseMessage is VImageMessage) {
      final msg = vBaseMessage as VImageMessage;
      return Stack(
        children: [
          VPlatformCacheImageWidget(
            source: msg.data.fileSource,
            size: const Size(50, 50),
            borderRadius: BorderRadius.circular(10),
          ),
          PositionedDirectional(
            end: 1,
            top: 1,
            child: _getCloseIcon(onDismiss),
          )
        ],
      );
    }
    return _getCloseIcon(onDismiss);
  }

  Widget _getCloseIcon(VoidCallback onClose) {
    return InkWell(
      onTap: onClose,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
        child: const Icon(
          Icons.close,
          size: 17,
        ),
      ),
    );
  }
}
