// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textless/textless.dart';

/// A widget that displays the last time a message was sent in a chat. /// /// This widget takes a [lastMessageTime] [DateTime] object as an argument and /// displays it in a user-friendly format. /// /// Typical usage: /// /// dart /// ChatLastMsgTime(lastMessageTime: DateTime.now()) /// /// /// This would display the current time in a user-friendly format. class ChatLastMsgTime extends StatelessWidget { final DateTime lastMessageTime;
class ChatLastMsgTime extends StatelessWidget {
  /// The [DateTime] object representing the last time a message was sent in a chat.
  final DateTime lastMessageTime;
  final String yesterdayLabel;

  /// Creates a new instance of [ChatLastMsgTime].
  const ChatLastMsgTime({
    Key? key,
    required this.lastMessageTime,
    required this.yesterdayLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();
    final difference = now.difference(lastMessageTime).inDays;
    if (difference == 0) {
      //same day
      return DateFormat.jm(Localizations.localeOf(context).languageCode)
          .format(lastMessageTime)
          .cap;
    }
    if (difference == 1) {
      return yesterdayLabel.cap;
    }
    if (difference <= 7) {
      return DateFormat.E(Localizations.localeOf(context).languageCode)
          .format(lastMessageTime)
          .cap;
    }
    return DateFormat.yMd(Localizations.localeOf(context).languageCode)
        .format(lastMessageTime)
        .cap;
  }
}
