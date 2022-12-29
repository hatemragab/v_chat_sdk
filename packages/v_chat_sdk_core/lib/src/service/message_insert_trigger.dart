import 'dart:async';

import 'package:v_chat_sdk_core/src/events/events.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';

import '../utils/event_bus.dart';

abstract class MessageInsertionDaemon {
  static StreamSubscription? _subscription;

  static void start() {
    _subscription = EventBusSingleton.instance.vChatEvents
        .on<VMessageEvents>()
        .listen((event) {
      if (event is VInsertMessageEvent) {
        _onNewInsert(event.messageModel);
      }
    });
  }

  static void _onNewInsert(VBaseMessage message) async {
    //print("onNewInsertonNewInsert $message");
  }

  static void close() {
    _subscription?.cancel();
  }
}
