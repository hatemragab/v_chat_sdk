// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

/// EventsDaemon class is responsible for managing message events.
class EventsDaemon {
  /// A [StreamSubscription] for message events.
  StreamSubscription? _messageSubscription;

  /// Event bus emitter instance.
  final _emitter = VEventBusSingleton.vEventBus;

  /// Native API controller instance.
  final _nativeAPi = VChatController.I.nativeApi;

  /// Starts listening to message events.
  void start() {
    _messageSubscription = _emitter
        .on<VMessageEvents>()
        .where((element) => element is VInsertMessageEvent)
        .listen((event) async {
      // When a new message is inserted
      if (event is VInsertMessageEvent) {
        await _onNewInsert(event.messageModel);
        if (VPlatforms.isWeb && !event.messageModel.isMeSender) {
          /// In case of web platform and the message sender is not the current user,
          /// fires a new notification event.
          _emitter.fire(
            VOnNewNotifications(
              message: event.messageModel,
            ),
          );
        }
      }
    });
  }

  /// Handles a new message insertion.
  ///
  /// Delivers the message if it's not sent by the current user and
  /// checks if the room exists and creates it if it doesn't.
  Future<void> _onNewInsert(VBaseMessage message) async {
    // Delivers the message if it's not sent by the current user
    if (!message.isMeSender) {
      _nativeAPi.remote.socketIo.emitDeliverRoomMessages(
        message.roomId,
      );
    }

    // Check if the room exists and creates it if it doesn't
    final messageRoom = await _nativeAPi.local.room.isRoomExist(message.roomId);
    if (!messageRoom) {
      await Future.delayed(const Duration(seconds: 2, milliseconds: 200));
      final apiRoom = await _nativeAPi.remote.room.getRoomById(message.roomId);
      await _nativeAPi.local.room.safeInsertRoom(apiRoom);
    }

    // Process specific message types
    if (message is VInfoMessage) {
      // Process info message
      if (message.data.action == VMessageInfoType.updateTitle) {
        // If the message is about room title update, update the room name locally.
        await _nativeAPi.local.room.updateRoomName(
          VUpdateRoomNameEvent(
            roomId: message.roomId,
            name: message.data.targetName,
          ),
        );
      } else if (message.data.action == VMessageInfoType.updateImage) {
        // If the message is about room image update, update the room image locally.
        await _nativeAPi.local.room.updateRoomImage(
          VUpdateRoomImageEvent(
            roomId: message.roomId,
            image: message.data.targetName,
          ),
        );
      }
    }

    // If the message is a voice message from a mobile platform and not sent by the current user,
    // get the file from cache.
    if (message is VVoiceMessage &&
        VPlatforms.isMobile &&
        !message.isMeSender) {
      await DefaultCacheManager().getSingleFile(
        message.data.fileSource.url!,
        key: message.data.fileSource.getUrlPath,
      );
    }
  }

  /// Stops listening to the message events.
  void close() {
    _messageSubscription?.cancel();
  }
}
