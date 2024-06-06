// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTimeWidget extends StatelessWidget {
  final DateTime dateTime;

  const MessageTimeWidget({
    super.key,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.jm(Localizations.localeOf(context).languageCode)
          .format(dateTime.toLocal()),
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.white, fontWeight: FontWeight.w200, fontSize: 11),
    );
  }
}
