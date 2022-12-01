import 'package:collection/collection.dart';

import '../../../../../v_chat_sdk_core.dart';
import '../../abstraction/base_local_message_repo.dart';

extension X on List<VBaseMessage> {
  List<VBaseMessage> sortById() {
    sort((a, b) {
      return b.id.compareTo(a.id);
    });
    return this;
  }
}

class MemoryMessageImp extends BaseLocalMessageRepo {
  final _messages = <VBaseMessage>[];

  @override
  Future<int> delete(VDeleteMessageEvent event) {
    _messages.removeWhere((e) => event.localId == e.localId);
    return Future.value(1);
  }

  @override
  Future<VBaseMessage?> findByLocalId(String localId) {
    return Future.value(
      _messages.singleWhereOrNull((e) => e.localId == localId),
    );
  }

  @override
  Future<int> insert(VInsertMessageEvent event) async {
    final old = await findByLocalId(event.localId);
    if (old != null) {
      throw VChatDartException(
          exception: "message already exist $old in web db");
    }
    _messages.add(event.messageModel);
    return Future.value(1);
  }

  @override
  Future<List<VBaseMessage>> search({
    required String text,
    required String roomId,
    int limit = 150,
  }) {
    return Future.value(
      _messages
          .where(
            (e) =>
                e.roomId == roomId &&
                e.content.toLowerCase().startsWith(text.toLowerCase()),
          )
          .toList()
          .sortById()
          .take(limit)
          .toList(),
    );
  }

  @override
  Future<int> updateMessageStatus(VUpdateMessageStatusEvent event) async {
    final msg = await findByLocalId(event.localId);
    if (msg == null) return 0;
    msg.messageStatus = event.messageSendingStatusEnum;
    return Future.value(1);
  }

  @override
  Future<int> updateMessageType(VUpdateMessageTypeEvent event) async {
    final msg = await findByLocalId(event.localId);
    if (msg == null) return 0;
    msg.messageType = event.messageType;
    return Future.value(1);
  }

  @override
  Future<int> updateMessagesToDeliver(
    VUpdateMessageDeliverEvent event,
  ) async {
    for (final m in _messages) {
      if (m.roomId == event.roomId &&
          m.senderId == event.deliverRoomMessagesModel.userId &&
          m.deliveredAt == null) {
        m.deliveredAt = event.deliverRoomMessagesModel.date;
      }
    }
    return Future.value(1);
  }

  @override
  Future<int> updateMessagesToSeen(VUpdateMessageSeenEvent event) async {
    for (final m in _messages) {
      if (m.roomId == event.roomId &&
          m.senderId == event.onEnterRoomModel.userId &&
          m.seenAt == null) {
        m.seenAt = event.onEnterRoomModel.date;
        m.deliveredAt ??= event.onEnterRoomModel.date;
      }
    }
    return Future.value(1);
  }

  @override
  Future<List<VBaseMessage>> getMessagesByStatus({
    required MessageSendingStatusEnum status,
    int limit = 50,
  }) {
    return Future.value(
      _messages.where((e) => e.messageStatus == status).take(limit).toList(),
    );
  }

  @override
  Future<VBaseMessage?> findOneMessageBeforeThis(
    String createdAt,
    String roomId,
  ) async {
    return Future.value();
  }

  @override
  Future<List<VBaseMessage>> getRoomMessages(
    String roomId, {
    int limit = 100,
  }) async {
    return Future.value(
      _messages
          .where((e) => e.roomId == roomId)
          .toList()
          .sortById()
          .take(limit)
          .toList(),
    );
  }

  @override
  Future<int> updateMessagesFromSendingToError() {
    for (final e in _messages) {
      e.messageStatus = MessageSendingStatusEnum.error;
    }
    return Future.value(1);
  }

  @override
  Future<int> updateMessageIdByLocalId({
    required String localId,
    required String messageId,
  }) async {
    final msg = await findByLocalId(localId);
    if (msg == null) return Future.value(0);
    msg.id = messageId;
    return Future.value(1);
  }

  @override
  Future<int> reCreate() {
    _messages.clear();
    return Future.value(1);
  }

  @override
  Future<int> deleteAllMessagesByRoomId(String roomId) {
    _messages.removeWhere((e) => e.roomId == roomId);
    return Future.value(1);
  }

  @override
  Future<int> insertMany(List<VBaseMessage> messages) {
    for (final msg in messages) {
      if (!_messages.contains(msg)) {
        _messages.add(msg);
      }
    }
    return Future.value(1);
  }
}
