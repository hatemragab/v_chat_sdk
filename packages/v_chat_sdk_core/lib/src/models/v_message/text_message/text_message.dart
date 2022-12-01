import '../../../../v_chat_sdk_core.dart';
import '../base_message/base_message.dart';

class VTextMessage extends VBaseMessage {
  VTextMessage({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.senderImageThumb,
    required super.messageStatus,
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

  VTextMessage.buildMessage({
    required super.content,
    required super.roomId,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(messageType: MessageType.text);

  VTextMessage.fromRemoteMap(super.map) : super.fromRemoteMap();

  VTextMessage.fromLocalMap(super.map) : super.fromLocalMap();

  @override
  bool operator ==(Object other) =>
      other is VBaseMessage && localId == other.localId;

  @override
  int get hashCode => localId.hashCode;
}
