// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../v_chat/platform_cache_image_widget.dart';

class ReplyMsgWidget extends StatelessWidget {
  final VBaseMessage vBaseMessage;
  final VoidCallback onDismiss;
  final String replyToYourSelf;

  const ReplyMsgWidget({
    super.key,
    required this.vBaseMessage,
    required this.onDismiss,
    required this.replyToYourSelf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTitle(context),
                  maxLines: 1,
                ),
                Text(
                  vBaseMessage.realContentMentionParsedWithAt,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          getImage()
        ],
      ),
    );
  }

  String getTitle(BuildContext context) {
    if (vBaseMessage.isMeSender) {
      return replyToYourSelf;
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
