import 'dart:async';

import 'package:v_chat_sdk_core/src/events/events.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/v_chat_controller.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class EventsDaemon {
  StreamSubscription? _messageSubscription;
  final _emitter = VEventBusSingleton.vEventBus;
  final _nativeAPi = VChatController.I.nativeApi;

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
      _nativeAPi.remote.socketIo.emitDeliverRoomMessages(
        message.roomId,
      );
    }
    final messageRoom = await _nativeAPi.local.room.isRoomExist(message.roomId);
    if (!messageRoom) {
      // we need to request it
      await Future.delayed(const Duration(seconds: 3));
      final apiRoom = await _nativeAPi.remote.room.getRoomById(message.roomId);
      await _nativeAPi.local.room.safeInsertRoom(apiRoom);
    }
  }

  void close() {
    _messageSubscription?.cancel();
  }
}
