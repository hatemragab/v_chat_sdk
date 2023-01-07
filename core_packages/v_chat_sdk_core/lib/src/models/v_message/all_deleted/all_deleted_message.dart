import '../base_message/v_base_message.dart';

class VAllDeletedMessage extends VBaseMessage {
  VAllDeletedMessage({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.emitStatus,
    required super.senderImageThumb,
    required super.platform,
    required super.roomId,
    required super.content,
    required super.messageType,
    required super.localId,
    required super.createdAt,
    required super.updatedAt,
    required super.replyTo,
    required super.seenAt,
    required super.deliveredAt,
    required super.forwardId,
    required super.deletedAt,
    required super.parentBroadcastId,
    required super.isStared,
  });

  VAllDeletedMessage.fromRemoteMap(super.map) : super.fromRemoteMap();

  VAllDeletedMessage.fromLocalMap(super.map) : super.fromLocalMap();
}
