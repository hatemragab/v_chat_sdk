// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:v_chat_sdk_core/src/events/app_life_cycle.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VAppLifecycleState {
  static bool isAppActive = false;

  // final _log = Logger('VAppLifecycleState');
  Timer? _timer;

  VAppLifecycleState() {
    if (!VPlatforms.isMobile) return;
    FGBGEvents.stream.listen((event) {
      switch (event) {
        case FGBGType.foreground:
          _timer?.cancel();
          VEventBusSingleton.vEventBus
              .fire(const VAppLifeCycle(isGoBackground: false));

          ///start connect
          if (!SocketController.instance.isSocketConnected) {
            SocketController.instance.connect();
          }
          break;
        case FGBGType.background:

          /// disconnect timer
          if (VAppPick.isPicking) {
            return;
          }
          _timer?.cancel();
          _timer = Timer(const Duration(seconds: 5), () {
            VEventBusSingleton.vEventBus.fire(
              const VAppLifeCycle(
                isGoBackground: true,
              ),
            );
            SocketController.instance.disconnect();
          });
          break;
      }
    });
  }
}
