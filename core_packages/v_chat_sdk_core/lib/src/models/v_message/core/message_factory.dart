import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class MessageFactory {
  static VBaseMessage createBaseMessage(Map<String, dynamic> map) {
    final typeNullable = map[MessageTable.columnMessageType] as String?;
    if (typeNullable != null) {
      return _createMessageFromLocal(map);
    }
    final type = VMessageType.values.byName(map['mT'] as String);
    switch (type) {
      case VMessageType.text:
        return VTextMessage.fromRemoteMap(map);
      case VMessageType.image:
        return VImageMessage.fromRemoteMap(map);
      case VMessageType.file:
        return VFileMessage.fromRemoteMap(map);
      case VMessageType.video:
        return VVideoMessage.fromRemoteMap(map);
      case VMessageType.voice:
        return VVoiceMessage.fromRemoteMap(map);
      case VMessageType.location:
        return VLocationMessage.fromRemoteMap(map);
      case VMessageType.allDeleted:
        return VAllDeletedMessage.fromRemoteMap(map);
      case VMessageType.info:
        return VInfoMessage.fromRemoteMap(map);
      case VMessageType.call:
        return VCallMessage.fromRemoteMap(map);
      case VMessageType.custom:
        return VCustomMessage.fromRemoteMap(map);
    }
  }

  static VBaseMessage _createMessageFromLocal(
    Map<String, dynamic> map,
  ) {
    final type = VMessageType.values
        .byName(map[MessageTable.columnMessageType] as String);
    switch (type) {
      case VMessageType.text:
        return VTextMessage.fromLocalMap(map);
      case VMessageType.image:
        return VImageMessage.fromLocalMap(map);
      case VMessageType.file:
        return VFileMessage.fromLocalMap(map);
      case VMessageType.video:
        return VVideoMessage.fromLocalMap(map);
      case VMessageType.voice:
        return VVoiceMessage.fromLocalMap(map);
      case VMessageType.location:
        return VLocationMessage.fromLocalMap(map);
      case VMessageType.allDeleted:
        return VAllDeletedMessage.fromLocalMap(map);
      case VMessageType.info:
        return VInfoMessage.fromLocalMap(map);
      case VMessageType.call:
        return VCallMessage.fromLocalMap(map);
      case VMessageType.custom:
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
          source: msg.data.fileSource,
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
          source: msg.data.fileSource,
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
        file2: msg.data.thumbImage == null
            ? null
            : await HttpHelpers.getMultipartFile(
                source: msg.data.thumbImage!.fileSource,
              ),
        file1: await HttpHelpers.getMultipartFile(
          source: msg.data.fileSource,
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
