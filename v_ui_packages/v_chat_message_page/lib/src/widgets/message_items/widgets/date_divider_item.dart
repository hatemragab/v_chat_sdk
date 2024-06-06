// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';

class DateDividerItem extends StatelessWidget {
  final DateTime dateTime;
  final String today;
  final String yesterday;

  const DateDividerItem({
    Key? key,
    required this.dateTime,
    required this.today,
    required this.yesterday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = "";
    final now = DateTime.now().toLocal();
    final difference = now.difference(dateTime).inDays;
    if (difference == 0) {
      text = today;
    } else if (difference == 1) {
      text = yesterday;
    } else if (difference <= 7) {
      //will print the day name EX (sunday ,...)
      text = DateFormat.E(Localizations.localeOf(context).languageCode)
          .format(dateTime);
    } else {
      //will print the time as (1/1/2000)
      text = DateFormat.yMd(Localizations.localeOf(context).languageCode)
          .format(dateTime);
    }
    final method = context.vMessageTheme.vMessageItemTheme.dateDivider;
    if (method != null) {
      return context.vMessageTheme.vMessageItemTheme.dateDivider!(
        context,
        dateTime,
        text,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                text,
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
