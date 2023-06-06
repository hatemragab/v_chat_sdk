// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:textless/textless.dart';

class MessageTimeWidget extends StatelessWidget {
  final DateTime dateTime;

  const MessageTimeWidget({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DateFormat.jm(Localizations.localeOf(context).languageCode)
          .format(dateTime.toLocal())
          .cap
          .size(11)
          .thin,
    );
  }
}
