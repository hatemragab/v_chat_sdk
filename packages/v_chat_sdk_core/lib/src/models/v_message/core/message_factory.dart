import 'package:v_chat_sdk_core/src/models/v_message/call_message/call_message.dart';
import 'package:v_chat_sdk_core/src/models/v_message/custom_message/custom_message.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../local_db/tables/message_table.dart';
import '../../../utils/http_helper.dart';

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
        return VCallMessage.fromRemoteMap(map);
      case MessageType.custom:
        return VCustomMessage.fromRemoteMap(map);
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
        return VCallMessage.fromLocalMap(map);
      case MessageType.custom:
        return VCustomMessage.fromLocalMap(map);
    }
  }

  static Future<VMessageUploadModel> createUploadMessage(
    VBaseMessage msg,
  ) async {
    if (msg.forwardId != null) {
      return createForwardUploadMessage(msg);
    }
    if (msg is VTextMessage) {
      return VMessageUploadModel(
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        msgLocalId: msg.localId,
      );
    }
    if (msg is VVoiceMessage) {
      return VMessageUploadModel(
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        msgLocalId: msg.localId,
        file1: await HttpHelpers.getMultipartFile(
          source: msg.fileSource.fileSource,
        ),
      );
    }
    if (msg is VLocationMessage) {
      return VMessageUploadModel(
        msgLocalId: msg.localId,
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
      );
    }
    if (msg is VFileMessage) {
      return VMessageUploadModel(
        msgLocalId: msg.localId,
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        file1: await HttpHelpers.getMultipartFile(
          source: msg.fileSource.fileSource,
        ),
      );
    }
    if (msg is VImageMessage) {
      return VMessageUploadModel(
        msgLocalId: msg.localId,
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
        file1: await HttpHelpers.getMultipartFile(
          source: msg.data.fileSource,
        ),
      );
    }
    if (msg is VVideoMessage) {
      return VMessageUploadModel(
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
    if (msg is VCustomMessage) {
      return VMessageUploadModel(
        msgLocalId: msg.localId,
        body: msg.toListOfPartValue(),
        roomId: msg.roomId,
      );
    }
    throw UnimplementedError(
      "createUploadMessage with type $msg not supported",
    );
  }

  static Future<VMessageUploadModel> createForwardUploadMessage(
    VBaseMessage msg,
  ) async {
    return VMessageUploadModel(
      body: msg.toListOfPartValue(),
      roomId: msg.roomId,
      msgLocalId: msg.localId,
    );
  }
}
