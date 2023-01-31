import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:v_chat_sdk_core/src/events/events.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/v_chat_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class EventsDaemon {
  StreamSubscription? _messageSubscription;
  final _emitter = VEventBusSingleton.vEventBus;
  final _nativeAPi = VChatController.I.nativeApi;

  void start() {
    _messageSubscription = _emitter
        .on<VMessageEvents>()
        .where((element) => element is VInsertMessageEvent)
        .listen((event) async {
      if (event is VInsertMessageEvent) {
        await _onNewInsert(event.messageModel);
        if (VPlatforms.isWeb && !event.messageModel.isMeSender) {
          ///we need to push notification event to the events
          _emitter.fire(
            VOnNewNotifications(
              message: event.messageModel,
            ),
          );
        }
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
      await Future.delayed(const Duration(seconds: 2, milliseconds: 200));
      final apiRoom = await _nativeAPi.remote.room.getRoomById(message.roomId);
      await _nativeAPi.local.room.safeInsertRoom(apiRoom);
    }
    if (message is VInfoMessage) {
      if (message.data.action == VMessageInfoType.updateTitle) {
        await _nativeAPi.local.room.updateRoomName(
          VUpdateRoomNameEvent(
            roomId: message.roomId,
            name: message.data.targetName,
          ),
        );
      } else if (message.data.action == VMessageInfoType.updateImage) {
        await _nativeAPi.local.room.updateRoomImage(
          VUpdateRoomImageEvent(
            roomId: message.roomId,
            image: message.data.targetName,
          ),
        );
      }
    }
    if (message is VVoiceMessage && VPlatforms.isMobile && !message.isMeSender) {
      await DefaultCacheManager().getSingleFile(
        message.data.fileSource.url!,
        key: message.data.fileSource.getUrlPath,
      );
    }
  }

  void close() {
    _messageSubscription?.cancel();
  }
}
