// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library v_chat_web_rtc;

import 'package:flutter/foundation.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_web_rtc/src/core/v_safe_api_call.dart';

export './src/call_nav.dart';
export './src/core/logger_stream.dart';
export './src/core/trans/trans.dart';
export 'src/core/trans/v_call_localization.dart';

void vInitCallListener() async {
  final remote = VChatController.I.nativeApi.remote;
  await remote.socketIo.socketCompleter.future;
  if (kDebugMode) print("vInitCallListener initialization Done");
  VChatController.I.nativeApi.streams.callStream.listen((event) {
    if (event is VOnNewCallEvent) {
      VChatController.I.vNavigator.callNavigator?.toCallee(
        VChatController.I.navigationContext,
        event.data,
      );
    }
  });
  vSafeApiCall<VOnNewCallEvent?>(
    request: () async {
      return remote.calls.getActiveCall();
    },
    onSuccess: (response) {
      if (response != null) {
        VChatController.I.vNavigator.callNavigator?.toCallee(
          VChatController.I.navigationContext,
          response.data,
        );
      }
    },
  );
}
