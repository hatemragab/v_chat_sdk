// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library v_chat_web_rtc;

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_web_rtc/src/core/extension.dart';
import 'package:v_chat_web_rtc/src/pages/callee/callee_page.dart';

export './src/call_nav.dart';
export './src/core/logger_stream.dart';

void vInitCallListener() async {
  final remote = VChatController.I.nativeApi.remote;
  await remote.socketIo.socketCompleter.future;
  print("vInitCallListener initialization Done");
  VChatController.I.nativeApi.streams.callStream.listen((event) {
    if (event is VOnNewCallEvent) {
      VChatController.I.navigationContext.toPage(
        VCalleePage(model: event.data),
      );
    }
  });
  vSafeApiCall<VOnNewCallEvent?>(
    request: () async {
      return remote.calls.getActiveCall();
    },
    onSuccess: (response) {
      if (response != null) {
        VChatController.I.navigationContext.toPage(
          VCalleePage(model: response.data),
        );
      }
    },
  );
}
