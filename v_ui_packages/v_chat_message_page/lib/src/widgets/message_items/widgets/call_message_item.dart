// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class CallMessageItem extends StatelessWidget {
  final VCallMessage message;

  const CallMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
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
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              dense: true,
              title: message.data.withVideo
                  ? VTrans.labelsOf(context).videoCall.text
                  : VTrans.labelsOf(context).audioCall.text,
              subtitle: _getSub(context),
            ),
          )
        ],
      ),
    );
  }

  Widget _getSub(BuildContext context) {
    if (message.data.duration != null) {
      return "${message.data.duration.toString()} S"
          .text
          .maxLine(2)
          .overflowEllipsis;
    }
    return message.data.callStatus
        .tr(context)
        .toString()
        .text
        .maxLine(2)
        .overflowEllipsis;
  }
}
