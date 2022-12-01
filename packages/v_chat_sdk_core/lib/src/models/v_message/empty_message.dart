import '../../../v_chat_sdk_core.dart';
import 'base_message/base_message.dart';

class VEmptyMessage extends VBaseMessage {
  VEmptyMessage()
      : super(
          id: "EmptyMessage",
          senderId: "EmptyMessage",
          senderName: "EmptyMessage",
          senderImageThumb: VFullUrlModel("Empty.url"),
          platform: "EmptyMessage",
          roomId: "EmptyMessage",
          content: "",
          messageType: MessageType.text,
          localId: "EmptyMessage",
          createdAt: DateTime.now().toLocal().toIso8601String(),
          updatedAt: DateTime.now().toLocal().toIso8601String(),
          replyTo: null,
          seenAt: null,
          isStared: false,
          contentTr: null,
          deliveredAt: null,
          messageStatus: MessageSendingStatusEnum.serverConfirm,
          forwardId: null,
          deletedAt: null,
          parentBroadcastId: null,
        );
}
