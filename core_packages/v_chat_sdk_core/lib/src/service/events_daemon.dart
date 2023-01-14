import 'dart:async';

import 'package:v_chat_sdk_core/src/events/events.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/v_chat_controller.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class EventsDaemon {
  StreamSubscription? _messageSubscription;
  final _emitter = VEventBusSingleton.vEventBus;

  void start() {
    _messageSubscription = _emitter
        .on<VMessageEvents>()
        .where((element) => element is VInsertMessageEvent)
        .listen((event) {
      if (event is VInsertMessageEvent) {
        _onNewInsert(event.messageModel);
      }
    });
  }

  Future<void> _onNewInsert(VBaseMessage message) async {
    if (!message.isMeSender) {
      ///deliver this message
      VChatController.I.nativeApi.remote.socketIo.emitDeliverRoomMessages(
        message.roomId,
      );
    }
    //print("onNewInsertonNewInsert $message");
  }

  void close() {
    _messageSubscription?.cancel();
  }
}
