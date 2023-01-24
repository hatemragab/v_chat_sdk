import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VAppLifecycleState with WidgetsBindingObserver {
  static bool isAppActive = false;

  static WidgetsBinding? get _widgetsBindingInstance => WidgetsBinding.instance;
  final _log = Logger('VAppLifecycleState');
  Timer? _timer;

  VAppLifecycleState() {
    _widgetsBindingInstance?.addObserver(this);
    FGBGEvents.stream.listen((event) {
      switch (event) {
        case FGBGType.foreground:

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
            SocketController.instance.disconnect();
          });
          break;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // switch (state) {
    //   case AppLifecycleState.resumed:
    //     isAppActive = true;
    //     _log.fine("AppLifecycleState.resumed:");
    //     break;
    //   case AppLifecycleState.inactive:
    //     isAppActive = false;
    //     _log.fine("AppLifecycleState.inactive:");
    //     break;
    //   case AppLifecycleState.paused:
    //     // _log.fine("AppLifecycleState.paused:");
    //     break;
    //   case AppLifecycleState.detached:
    //     break;
    // }
  }

  void dispose() {
    _widgetsBindingInstance?.removeObserver(this);
  }
}
