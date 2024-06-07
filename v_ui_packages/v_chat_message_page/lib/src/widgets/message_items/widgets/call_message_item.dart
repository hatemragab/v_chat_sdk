// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class CallMessageItem extends StatelessWidget {
  final VCallMessage message;
  final String audioCallLabel;
  final String callStatusLabel;

  const CallMessageItem({
    super.key,
    required this.message,
    required this.audioCallLabel,
    required this.callStatusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Icon(
              message.data.withVideo
                  ? PhosphorIcons.videoCameraFill
                  : PhosphorIcons.phoneCall,
              color: Colors.white,
              size: 30,
            ),
          ),
          Expanded(
            child: ListTile(
              //visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              dense: true,
              title: message.data.withVideo
                  ? Text(
                      audioCallLabel,
                      style: message.isMeSender
                          ? context.vMessageTheme.senderTextStyle
                              .copyWith(fontSize: 14)
                          : context.vMessageTheme.receiverTextStyle
                              .copyWith(fontSize: 14),
                    )
                  : Text(
                      audioCallLabel,
                      style: message.isMeSender
                          ? context.vMessageTheme.senderTextStyle
                              .copyWith(fontSize: 14)
                          : context.vMessageTheme.receiverTextStyle
                              .copyWith(fontSize: 14),
                    ),

              subtitle: _getSub(context),
            ),
          )
        ],
      ),
    );
  }

  Widget _getSub(BuildContext context) {
    if (message.data.duration != null) {
      return Text(
        "${message.data.duration.toString()} S",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: message.isMeSender
            ? context.vMessageTheme.senderTextStyle.copyWith(fontSize: 14)
            : context.vMessageTheme.receiverTextStyle.copyWith(fontSize: 14),
      );
    }
    return Text(
      callStatusLabel.toString(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: message.isMeSender
          ? context.vMessageTheme.senderTextStyle.copyWith(fontSize: 14)
          : context.vMessageTheme.receiverTextStyle.copyWith(fontSize: 14),
    );
  }
}
