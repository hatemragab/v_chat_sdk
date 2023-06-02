// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_message_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/message/memory_message_imp.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/message/sql_message_imp.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

/// Represents the Native Local Message that deals with the message data
/// in the VChat application, both on local (in memory and SQL) databases.
class NativeLocalMessage {
  late final BaseLocalMessageRepo _localMessageRepo;
  final _emitter = VEventBusSingleton.vEventBus;

  /// Creates a new instance of [NativeLocalMessage].
  ///
  /// Uses the appropriate local message repository (memory or SQL) based on the platform (Web or others).
  NativeLocalMessage(Database? database) {
    _localMessageRepo =
        VPlatforms.isWeb ? MemoryMessageImp() : SqlMessageImp(database!);
  }

  /// Inserts the given [message] into the local message repository.
  ///
  /// Emits a [VInsertMessageEvent] on successful insertion.
  ///
  /// Returns 1 if insertion is successful, otherwise 0.
  Future<int> insertMessage(VBaseMessage message) async {
    if (message is VEmptyMessage) return 0;

    final event = VInsertMessageEvent(
      messageModel: message,
      localId: message.localId,
      roomId: message.roomId,
    );

    await _localMessageRepo.insert(event);
    _emitter.fire(event);
    return 1;
  }

  /// Safely inserts the given [message] into the local message repository.
  ///
  /// This method delays for 500 milliseconds before checking if a message with the same
  /// localId exists. If not, it proceeds with the insertion.
  Future<int> safeInsertMessage(VBaseMessage message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (await getMessageByLocalId(message.localId) == null) {
      return insertMessage(message);
    }
    return 0;
  }

  /// Prepare the messages in the local message repository by updating messages' status
  /// from 'sending' to 'error'.
  Future<int> prepareMessages() async =>
      _localMessageRepo.updateMessagesFromSendingToError();

  /// Updates the status of the message in the local message repository based on the given [event].
  ///
  /// Emits a [VUpdateMessageStatusEvent] on successful update.
  Future<int> updateMessageSendingStatus(
    VUpdateMessageStatusEvent event,
  ) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessageStatus(event);
    return 1;
  }

  /// Deletes a message with the same localId as the given [msg] from the local message repository.
  ///
  /// Emits a [VDeleteMessageEvent] on successful deletion.
  Future<int> deleteMessageByLocalId(VBaseMessage msg) async {
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

  /// Deletes all messages in a room with the given [roomId] from the local message repository.
  Future<int> deleteMessageByRoomId(String roomId) async {
    await _localMessageRepo.deleteAllMessagesByRoomId(roomId);
    return 1;
  }

  /// Updates a message in the local message repository to be 'all deleted' based on the given [event].
  ///
  /// Emits a [VUpdateMessageAllDeletedEvent] on successful update.
  Future<int> updateMessageToAllDeleted(
    VUpdateMessageAllDeletedEvent event,
  ) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessageToAllDeleted(event);
    return 1;
  }

  /// Fully updates a message in the local message repository based on the given [message].
  ///
  /// Emits a [VUpdateMessageEvent] on successful update.
  Future<int> updateFullMessage(VBaseMessage message) async {
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

  /// Updates messages in the local message repository to be 'delivered' based on the given [event].
  ///
  /// Emits a [VUpdateMessageDeliverEvent] on successful update.
  Future<int> updateMessagesSetDeliver(VUpdateMessageDeliverEvent event) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessagesToDeliver(event);
    return 1;
  }

  /// Updates messages in the local message repository to be 'seen' based on the given [event].
  ///
  /// Emits a [VUpdateMessageSeenEvent] on successful update.
  Future<int> updateMessagesSetSeen(VUpdateMessageSeenEvent event) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessagesToSeen(event);
    return 1;
  }

  /// Fetches a message by its localId from the local message repository.
  Future<VBaseMessage?> getMessageByLocalId(String localId) async =>
      _localMessageRepo.findByLocalId(localId);

  /// Fetches all messages in a room with the given [roomId] and [filter] from the local message repository.
  Future<List<VBaseMessage>> getRoomMessages({
    required String roomId,
    required VRoomMessagesDto filter,
  }) async =>
      _localMessageRepo.getRoomMessages(roomId: roomId, filter: filter);

  /// Fetches all messages with an 'error' status from the local message repository.
  Future<List<VBaseMessage>> getUnSendMessages() async =>
      _localMessageRepo.getMessagesByStatus(status: VMessageEmitStatus.error);

  /// Searches messages in a room with the given [roomId] and a [text] from the local message repository.
  Future<List<VBaseMessage>> searchMessage(String text, String roomId) async =>
      _localMessageRepo.search(text: text, roomId: roomId);

  /// Caches multiple messages in the local message repository.
  Future<int> cacheRoomMessages(List<VBaseMessage> messageToInsert) async =>
      _localMessageRepo.insertMany(messageToInsert);

  /// Updates messages in the local message repository from 'sending' to 'error'.
  Future<int> updateMessagesFromSendingToError() async =>
      _localMessageRepo.updateMessagesFromSendingToError();

  /// Drops the existing message table and creates a new one in the local message repository.
  Future<void> reCreateMessageTable() => _localMessageRepo.reCreate();
}
