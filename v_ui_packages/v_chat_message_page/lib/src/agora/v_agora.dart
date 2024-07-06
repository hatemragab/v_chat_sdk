// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../v_chat/v_safe_api_call.dart';

export 'core/call_navigator.dart';
export 'core/v_call_localization.dart';

void vInitCallListener(BuildContext context) async {
  final remote = VChatController.I.nativeApi.remote;
  await remote.socketIo.socketCompleter.future;
  if (kDebugMode) print("vInitCallListener initialization Done");
  VChatController.I.nativeApi.streams.callStream.listen((event) {
    if (event is VOnNewCallEvent) {
      VChatController.I.vNavigator.callNavigator?.toPickUp(
        context,
        event.data,
      );
    }
  });
  getActiveCall(context);
  _listenToSocket(context);
}

void _listenToSocket(BuildContext context) {
  VChatController.I.nativeStreams.socketStatusStream.listen((e) {
    if (e.isConnected && e.connectTimes != 1) {
      getActiveCall(context);
    } else {
      //
    }
  });
}

void getActiveCall(BuildContext context) {
  final remote = VChatController.I.nativeApi.remote;
  vSafeApiCall<VOnNewCallEvent?>(
    request: () async {
      return remote.calls.getActiveCall();
    },
    onSuccess: (response) {
      if (response != null) {
        VChatController.I.vNavigator.callNavigator?.toPickUp(
          context,
          response.data,
        );
      }
    },
  );
}
