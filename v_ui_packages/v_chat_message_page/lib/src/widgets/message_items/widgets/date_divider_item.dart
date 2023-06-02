// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class DateDividerItem extends StatelessWidget {
  final DateTime dateTime;

  const DateDividerItem({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = "";
    final now = DateTime.now().toLocal();
    final difference = now.difference(dateTime).inDays;
    if (difference == 0) {
      text = VTrans.of(context).labels.today;
    } else if (difference == 1) {
      text = VTrans.of(context).labels.yesterday;
    } else if (difference <= 7) {
      //will print the day name EX (sunday ,...)
      text = DateFormat.E(VAppConstants.sdkLanguage).format(dateTime);
    } else {
      //will print the time as (1/1/2000)
      text = DateFormat.yMd(VAppConstants.sdkLanguage).format(dateTime);
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
              child: text.text.color(Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
