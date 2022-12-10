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

  static VTextMessage getFakeMessage(String id) {
    return VTextMessage(
      id: "msg$id",
      senderId: "VCHAT_V2_FAKE_ID",
      senderName: "senderName",
      senderImageThumb: VFullUrlModel("https://picsum.photos/300/300", true),
      messageStatus: MessageSendingStatusEnum.serverConfirm,
      platform: "Android",
      roomId: id,
      content: "content $id",
      messageType: MessageType.text,
      localId: "localId",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      replyTo: null,
      seenAt: null,
      deliveredAt: null,
      forwardId: null,
      deletedAt: null,
      parentBroadcastId: null,
      isStared: false,
    );
  }
}
