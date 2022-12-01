import '../../../../v_chat_sdk_core.dart';

abstract class BaseLocalMessageRepo {
  Future<int> insert(VInsertMessageEvent event);

  Future<int> delete(VDeleteMessageEvent event);

  Future<int> deleteAllMessagesByRoomId(String roomId);

  Future<int> updateMessageType(VUpdateMessageTypeEvent event);

  Future<int> updateMessageStatus(VUpdateMessageStatusEvent event);

  Future<int> updateMessagesToSeen(VUpdateMessageSeenEvent event);

  Future<int> updateMessagesToDeliver(VUpdateMessageDeliverEvent event);
  Future<int> insertMany(List<VBaseMessage> messages);
  Future<int> updateMessageIdByLocalId({
    required String localId,
    required String messageId,
  });

  Future<int> updateMessagesFromSendingToError();

  Future<void> reCreate();

  Future<VBaseMessage?> findByLocalId(String localId);

  Future<VBaseMessage?> findOneMessageBeforeThis(
    String createdAt,
    String roomId,
  );

  Future<List<VBaseMessage>> search({
    required String text,
    required String roomId,
    int limit = 150,
  });

  Future<List<VBaseMessage>> getRoomMessages(
    String roomId, {
    int limit = 100,
  });

  Future<List<VBaseMessage>> getMessagesByStatus({
    required MessageSendingStatusEnum status,
    int limit = 50,
  });
}
