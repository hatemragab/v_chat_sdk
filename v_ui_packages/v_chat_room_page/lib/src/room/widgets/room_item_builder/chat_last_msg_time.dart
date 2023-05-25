// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class ChatLastMsgTime extends StatelessWidget {
  final DateTime lastMessageTime;

  const ChatLastMsgTime({
    Key? key,
    required this.lastMessageTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();
    final difference = now.difference(lastMessageTime).inDays;
    if (difference == 0) {
      //same day
      return DateFormat.jm(VAppConstants.sdkLanguage)
          .format(lastMessageTime)
          .cap;
    }
    if (difference == 1) {
      return VTrans.labelsOf(context).yesterday.cap;
    }
    if (difference <= 7) {
      return DateFormat.E(VAppConstants.sdkLanguage)
          .format(lastMessageTime)
          .cap;
    }
    return DateFormat.yMd(VAppConstants.sdkLanguage)
        .format(lastMessageTime)
        .cap;
  }
}
