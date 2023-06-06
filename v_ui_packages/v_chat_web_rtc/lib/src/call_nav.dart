// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_web_rtc/src/core/extension.dart';
import 'package:v_chat_web_rtc/src/core/trans/trans.dart';
import 'package:v_chat_web_rtc/src/pages/callee/callee_page.dart';
import 'package:v_chat_web_rtc/src/pages/caller/caller_page.dart';

final vDefaultCallNavigator = VCallNavigator(
  toCallee: (context, model) {
    context.toPage(VCalleePage(
      model: model,
      localization: VCallLocalization.fromEnglish(),
    ));
  },
  toCaller: (context, dto) {
    context.toPage(VCallerPage(
      dto: dto,
      localization: VCallLocalization.fromEnglish(),
    ));
  },
);
