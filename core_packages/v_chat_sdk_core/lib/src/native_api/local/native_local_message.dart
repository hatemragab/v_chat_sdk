// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_message_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/message/memory_message_imp.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/message/sql_message_imp.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class NativeLocalMessage {
  late BaseLocalMessageRepo _localMessageRepo;
  final _emitter = VEventBusSingleton.vEventBus;

  NativeLocalMessage(Database? database) {
    if (VPlatforms.isWeb) {
      _localMessageRepo = MemoryMessageImp();
    } else {
      _localMessageRepo = SqlMessageImp(database!);
    }
  }

  Future<int> insertMessage(
    VBaseMessage message,
  ) async {
    if (message is VEmptyMessage) {
      return 0;
    }
    final event = VInsertMessageEvent(
      messageModel: message,
      localId: message.localId,
      roomId: message.roomId,
    );
    await _localMessageRepo.insert(
      event,
    );
    _emitter.fire(event);
    return 1;
  }

  Future<int> safeInsertMessage(VBaseMessage message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (await getMessageByLocalId(message.localId) == null) {
      return insertMessage(message);
    }
    return 0;
  }

  Future<int> prepareMessages() async {
    return _localMessageRepo.updateMessagesFromSendingToError();
  }

  Future<int> updateMessageSendingStatus(
    VUpdateMessageStatusEvent event,
  ) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessageStatus(event);
    return 1;
  }

  Future<int> deleteMessageByLocalId(
    VBaseMessage msg,
  ) async {
    final event = VDeleteMessageEvent(
      localId: msg.localId,
      roomId: msg.roomId,
    );
    final message = await _localMessageRepo.findByLocalId(event.localId);
    final beforeMsg = await _localMessageRepo.findOneMessageBeforeThis(
      message!.createdAt,
      message.roomId,
    );
    final newEvent = VDeleteMessageEvent(
      localId: msg.localId,
      roomId: msg.roomId,
      upMessage: beforeMsg,
    );
    await _localMessageRepo.delete(newEvent);
    _emitter.fire(newEvent);
    return 1;
  }

  Future<int> deleteMessageByRoomId(
    String roomId,
  ) async {
    await _localMessageRepo.deleteAllMessagesByRoomId(roomId);
    return 1;
  }

  Future<int> updateMessageToAllDeleted(
    VUpdateMessageAllDeletedEvent event,
  ) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessageToAllDeleted(event);
    return 1;
  }

  Future<int> updateFullMessage(
    VBaseMessage message,
  ) async {
    await _localMessageRepo.updateFullMessage(baseMessage: message);
    _emitter.fire(
      VUpdateMessageEvent(
        roomId: message.roomId,
        localId: message.localId,
        messageModel: message,
      ),
    );
    return 1;
  }

  Future<int> updateMessagesSetDeliver(
    VUpdateMessageDeliverEvent event,
  ) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessagesToDeliver(event);
    return 1;
  }

  Future<int> updateMessagesSetSeen(
    VUpdateMessageSeenEvent event,
  ) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessagesToSeen(event);
    return 1;
  }

  Future<VBaseMessage?> getMessageByLocalId(String localId) async {
    return _localMessageRepo.findByLocalId(localId);
  }

  Future<List<VBaseMessage>> getRoomMessages({
    required String roomId,
    required VRoomMessagesDto filter,
  }) async {
    return _localMessageRepo.getRoomMessages(
      roomId: roomId,
      filter: filter,
    );
  }

  Future<List<VBaseMessage>> getUnSendMessages() async {
    return _localMessageRepo.getMessagesByStatus(
      status: VMessageEmitStatus.error,
    );
  }

  Future<List<VBaseMessage>> searchMessage(
    String text,
    String roomId,
  ) async {
    return _localMessageRepo.search(text: text, roomId: roomId);
  }

  Future<int> cacheRoomMessages(List<VBaseMessage> messageToInsert) async {
    return _localMessageRepo.insertMany(
      messageToInsert,
    );
  }

  Future<int> updateMessagesFromSendingToError() async {
    return _localMessageRepo.updateMessagesFromSendingToError();
  }

  Future<void> reCreateMessageTable() {
    return _localMessageRepo.reCreate();
  }
}
