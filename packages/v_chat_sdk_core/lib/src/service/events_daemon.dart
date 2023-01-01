import 'dart:async';

import 'package:v_chat_sdk_core/src/events/events.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/v_chat_controller.dart';

import '../utils/event_bus.dart';

abstract class EventsDaemon {
  static StreamSubscription? _messageSubscription;
  static final _emitter = EventBusSingleton.instance.vChatEvents;

  static void start() {
    _messageSubscription = _emitter
        .on<VMessageEvents>()
        .where((element) => element is VInsertMessageEvent)
        .listen((event) {
      if (event is VInsertMessageEvent) {
        _onNewInsert(event.messageModel);
      }
    });
  }

  static void _onNewInsert(VBaseMessage message) async {
    if (!message.isMeSender) {
      ///deliver this message
      VChatController.I.nativeApi.remote.socketIo.emitDeliverRoomMessages(
        message.roomId,
      );
    }
    //print("onNewInsertonNewInsert $message");
  }

  static void close() {
    _messageSubscription?.cancel();
  }
}
