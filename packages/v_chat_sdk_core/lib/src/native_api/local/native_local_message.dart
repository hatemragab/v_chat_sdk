import 'package:sqflite/sqflite.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../local_db/core/abstraction/base_local_message_repo.dart';
import '../../local_db/core/imp/message/memory_message_imp.dart';
import '../../local_db/core/imp/message/sql_message_imp.dart';
import '../../utils/event_bus.dart';

class NativeLocalMessage {
  late BaseLocalMessageRepo _localMessageRepo;
  final _emitter = EventBusSingleton.instance.vChatEvents;
  Stream<VMessageEvents> get messageStream => _emitter.on<VMessageEvents>();
  NativeLocalMessage(Database database) {
    if (Platforms.isWeb) {
      _localMessageRepo = MemoryMessageImp();
    } else {
      _localMessageRepo = SqlMessageImp(database);
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
    await _localMessageRepo.delete(event);
    event.upMessage = beforeMsg;
    _emitter.fire(event);
    return 1;
  }

  Future<int> updateMessageType(
    VUpdateMessageTypeEvent event,
  ) async {
    _emitter.fire(event);
    await _localMessageRepo.updateMessageType(event);
    return 1;
  }

  Future<int> updateMessageIdByLocalId(
    VBaseMessage message,
  ) async {
    await _localMessageRepo.updateMessageIdByLocalId(
      localId: message.localId,
      messageId: message.id,
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

  Future<List<VBaseMessage>> getRoomMessages(String roomId) async {
    return _localMessageRepo.getRoomMessages(roomId);
  }

  Future<List<VBaseMessage>> getUnSendMessages() async {
    return _localMessageRepo.getMessagesByStatus(
        status: MessageSendingStatusEnum.error);
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
