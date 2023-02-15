// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_message_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/message/memory_message_imp.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/message/sql_message_imp.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

mixin MessageLocalStorage {
  late BaseLocalMessageRepo localMessageRepo;
  final emitter = VEventBusSingleton.vEventBus;

  void initMessageLocalStorage({
    required Database database,
  }) {
    if (VPlatforms.isWeb) {
      localMessageRepo = MemoryMessageImp();
    } else {
      localMessageRepo = SqlMessageImp(database);
    }
  }

  Future<int> updateMessageSendingStatus(
    VUpdateMessageStatusEvent event,
  ) async {
    emitter.fire(event);
    await localMessageRepo.updateMessageStatus(event);
    return 1;
  }

  Future<int> deleteMessageByLocalId(
    VBaseMessage message,
  ) async {
    final event = VDeleteMessageEvent(
      localId: message.localId,
      roomId: message.roomId,
    );
    final beforeMsg = await localMessageRepo.findOneMessageBeforeThis(
      message.id,
      message.roomId,
    );
    await localMessageRepo.delete(event);
    emitter.fire(
      VDeleteMessageEvent(
        localId: message.localId,
        roomId: message.roomId,
        upMessage: beforeMsg,
      ),
    );
    return 1;
  }

  Future<int> updateMessageType(
    VUpdateMessageTypeEvent event,
  ) async {
    emitter.fire(event);
    await localMessageRepo.updateMessageType(event);
    return 1;
  }

  Future<int> updateFullMessage(
    VBaseMessage message,
  ) async {
    await localMessageRepo.updateFullMessage(
      baseMessage: message,
    );
    emitter.fire(
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
    emitter.fire(event);
    await localMessageRepo.updateMessagesToDeliver(event);
    return 1;
  }

  Future<int> updateMessagesSetSeen(
    VUpdateMessageSeenEvent event,
  ) async {
    emitter.fire(event);
    await localMessageRepo.updateMessagesToSeen(event);
    return 1;
  }

  Future<VBaseMessage?> getMessageByLocalId(String localId) async {
    return localMessageRepo.findByLocalId(localId);
  }

  // Future<List<VBaseMessage>> getRoomMessages({
  //   required String roomId,
  //   VMessageLocalFilterDto filterDto = const VMessageLocalFilterDto.init(),
  // }) async {
  //   return localMessageRepo.getRoomMessages(
  //     filter: filterDto,
  //     roomId: roomId,
  //   );
  // }

  Future<List<VBaseMessage>> getUnSendMessages() async {
    return localMessageRepo.getMessagesByStatus(
      status: VMessageEmitStatus.error,
    );
  }

  Future<List<VBaseMessage>> searchMessage(
    String text,
    String roomId,
  ) async {
    return localMessageRepo.search(text: text, roomId: roomId);
  }

  Future<int> cacheRoomMessages(List<VBaseMessage> messageToInsert) async {
    return localMessageRepo.insertMany(
      messageToInsert,
    );
  }

  Future<int> updateMessagesFromSendingToError() async {
    return localMessageRepo.updateMessagesFromSendingToError();
  }

  Future<void> reCreateMessageTable() {
    return localMessageRepo.reCreate();
  }
}
