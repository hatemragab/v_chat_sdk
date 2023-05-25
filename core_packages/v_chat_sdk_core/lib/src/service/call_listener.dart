// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../events/event_bus.dart';

class CallListener {
  final VNativeApi nativeApi;
  final VChatConfig vChatConfig;
  final VNavigator vNavigator;

  final _log = Logger('CallListener');

  CallListener(
    this.nativeApi,
    this.vChatConfig,
    this.vNavigator,
  ) {
    _init();
  }

  Future<void> _init() async {
    await nativeApi.remote.socketIo.socketCompleter.future;
    VEventBusSingleton.vEventBus.on<VCallEvents>().listen((event) {
      if (event is VOnNewCallEvent) {
        return;
      }
      if (event is VCallTimeoutEvent) {
        return;
      }
      if (event is VCallAcceptedEvent) {
        return;
      }
      if (event is VCallEndedEvent) {
        return;
      }
    });
  }
}
