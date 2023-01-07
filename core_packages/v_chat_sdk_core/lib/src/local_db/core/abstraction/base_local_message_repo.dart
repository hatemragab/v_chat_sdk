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

  Future<int> updateFullMessage({
    required VBaseMessage baseMessage,
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

  Future<List<VBaseMessage>> getRoomMessages({
    required String roomId,
    required VRoomMessagesDto filter,
  });

  Future<List<VBaseMessage>> getMessagesByStatus({
    required MessageEmitStatus status,
    int limit = 50,
  });
}
