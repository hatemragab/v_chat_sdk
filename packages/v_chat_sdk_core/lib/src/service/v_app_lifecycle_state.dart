import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class VAppLifecycleState with WidgetsBindingObserver {
  static bool isAppActive = false;

  static WidgetsBinding? get _widgetsBindingInstance => WidgetsBinding.instance;
  final _log = Logger('VAppLifecycleState');

  VAppLifecycleState() {
    _widgetsBindingInstance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        isAppActive = true;
        _log.fine("AppLifecycleState.resumed:");
        break;
      case AppLifecycleState.inactive:
        isAppActive = false;
        _log.fine("AppLifecycleState.inactive:");
        break;
      case AppLifecycleState.paused:
        // _log.fine("AppLifecycleState.paused:");
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void dispose() {
    _widgetsBindingInstance?.removeObserver(this);
  }
}
