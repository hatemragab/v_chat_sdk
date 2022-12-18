import 'package:sqflite/sqflite.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../utils/event_bus.dart';
import '../core/abstraction/base_local_message_repo.dart';
import '../core/imp/message/memory_message_imp.dart';
import '../core/imp/message/sql_message_imp.dart';

mixin MessageLocalStorage {
  late BaseLocalMessageRepo localMessageRepo;
  final emitter = EventBusSingleton.instance.vChatEvents;

  initMessageLocalStorage({
    required Database database,
  }) {
    if (Platforms.isWeb) {
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
    VBaseMessage msg,
  ) async {
    final event = VDeleteMessageEvent(
      localId: msg.localId,
      roomId: msg.roomId,
    );
    final message = await localMessageRepo.findByLocalId(event.localId);
    final beforeMsg = await localMessageRepo.findOneMessageBeforeThis(
      message!.createdAt,
      message.roomId,
    );
    await localMessageRepo.delete(event);
    event.upMessage = beforeMsg;
    emitter.fire(event);
    return 1;
  }

  Future<int> updateMessageType(
    VUpdateMessageTypeEvent event,
  ) async {
    emitter.fire(event);
    await localMessageRepo.updateMessageType(event);
    return 1;
  }

  Future<int> updateMessageIdByLocalId(
    VBaseMessage message,
  ) async {
    await localMessageRepo.updateMessageIdByLocalId(
      localId: message.localId,
      messageId: message.id,
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

  Future<List<VBaseMessage>> getRoomMessages(String roomId) async {
    return localMessageRepo.getRoomMessages(roomId);
  }

  Future<List<VBaseMessage>> getUnSendMessages() async {
    return localMessageRepo.getMessagesByStatus(
        status: MessageSendingStatusEnum.error);
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
