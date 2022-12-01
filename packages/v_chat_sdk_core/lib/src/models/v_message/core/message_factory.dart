import '../../../../v_chat_sdk_core.dart';
import '../../../local_db/tables/message_table.dart';
import '../../../utils/http_helper.dart';
import '../text_message/text_message.dart';

abstract class MessageFactory {
  static VBaseMessage createBaseMessage(Map<String, dynamic> map) {
    final typeNullable = map[MessageTable.columnMessageType] as String?;
    if (typeNullable != null) {
      return _createMessageFromLocal(map);
    }
    final type = MessageType.values.byName(map['mT'] as String);
    switch (type) {
      case MessageType.text:
        return VTextMessage.fromRemoteMap(map);
      case MessageType.image:
        return VImageMessage.fromRemoteMap(map);
      case MessageType.file:
        return VFileMessage.fromRemoteMap(map);
      case MessageType.video:
        return VVideoMessage.fromRemoteMap(map);
      case MessageType.voice:
        return VVoiceMessage.fromRemoteMap(map);
      case MessageType.location:
        return VLocationMessage.fromRemoteMap(map);
      case MessageType.allDeleted:
        return VAllDeletedMessage.fromRemoteMap(map);
      case MessageType.info:
        return VInfoMessage.fromRemoteMap(map);
      case MessageType.call:
        throw UnimplementedError("MessageType.call");
      case MessageType.bot:
        throw UnimplementedError("MessageType.bot");
    }
  }

  static VBaseMessage _createMessageFromLocal(
    Map<String, dynamic> map,
  ) {
    final type = MessageType.values
        .byName(map[MessageTable.columnMessageType] as String);
    switch (type) {
      case MessageType.text:
        return VTextMessage.fromLocalMap(map);
      case MessageType.image:
        return VImageMessage.fromLocalMap(map);
      case MessageType.file:
        return VFileMessage.fromLocalMap(map);
      case MessageType.video:
        return VVideoMessage.fromLocalMap(map);
      case MessageType.voice:
        return VVoiceMessage.fromLocalMap(map);
      case MessageType.location:
        return VLocationMessage.fromLocalMap(map);
      case MessageType.allDeleted:
        return VAllDeletedMessage.fromLocalMap(map);
      case MessageType.info:
        return VInfoMessage.fromLocalMap(map);
      case MessageType.call:
        throw UnimplementedError("MessageType.call");
      case MessageType.bot:
        throw UnimplementedError("MessageType.bot");
    }
  }

  static Future<MessageUploadModel> createUploadMessage(
    VBaseMessage msg,
  ) async {
    if (msg.forwardId != null) {
      return createForwardUploadMessage(msg);
    }
    if (msg is VTextMessage) {
      return MessageUploadModel(
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        msgLocalId: msg.localId,
      );
    }
    if (msg is VVoiceMessage) {
      return MessageUploadModel(
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        msgLocalId: msg.localId,
        file1: await HttpHelpers.getMultipartFile(
          source: msg.fileSource.fileSource,
        ),
      );
    }
    if (msg is VLocationMessage) {
      return MessageUploadModel(
        msgLocalId: msg.localId,
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
      );
    }
    if (msg is VFileMessage) {
      return MessageUploadModel(
        msgLocalId: msg.localId,
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        file1: await HttpHelpers.getMultipartFile(
          source: msg.fileSource.fileSource,
        ),
      );
    }
    if (msg is VImageMessage) {
      return MessageUploadModel(
        msgLocalId: msg.localId,
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        file1: await HttpHelpers.getMultipartFile(
          source: msg.fileSource.fileSource,
        ),
      );
    }
    if (msg is VVideoMessage) {
      return MessageUploadModel(
        msgLocalId: msg.localId,
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        file2: msg.fileSource.thumbImage == null
            ? null
            : await HttpHelpers.getMultipartFile(
                source: msg.fileSource.thumbImage!.fileSource,
              ),
        file1: await HttpHelpers.getMultipartFile(
          source: msg.fileSource.fileSource,
        ),
      );
    }
    throw UnimplementedError(
      "createUploadMessage with type $msg not supported",
    );
  }

  static Future<MessageUploadModel> createForwardUploadMessage(
    VBaseMessage msg,
  ) async {
    return MessageUploadModel(
      body: msg.toListOfPartValue(),
      roomId: msg.roomId,
      msgLocalId: msg.localId,
    );
  }
}
