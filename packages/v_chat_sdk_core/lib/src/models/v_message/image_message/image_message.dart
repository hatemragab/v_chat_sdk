import 'dart:convert';

import 'package:chopper/chopper.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../types/message_image_data.dart';
import '../base_message/base_message.dart';
import '../db_tables_name.dart';

class VImageMessage extends VBaseMessage {
  final MessageImageData fileSource;

  VImageMessage({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.messageStatus,
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
    required super.contentTr,
    required this.fileSource,
  });

  VImageMessage.fromRemoteMap(super.map)
      : fileSource = MessageImageData.fromMap(
          map['msgAtt'] as Map<String, dynamic>,
        ),
        super.fromRemoteMap();

  VImageMessage.fromLocalMap(super.map)
      : fileSource = MessageImageData.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String)
              as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  @override
  Map<String, dynamic> toRemoteMap() {
    return {...super.toRemoteMap(), 'msgAtt': fileSource.toMap()};
  }

  VImageMessage.buildMessage({
    required super.roomId,
    required this.fileSource,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          content: AppConstants.thisContentIsImage,
          messageType: MessageType.image,
        );

  @override
  List<PartValue> toListOfPartValue() {
    return [
      ...super.toListOfPartValue(),
    ];
  }

  @override
  String toString() {
    return 'ImageMessage{fileSource: $fileSource}';
  }

  @override
  Map<String, dynamic> toLocalMap({
    bool withOutConTr = false,
  }) {
    return {
      ...super.toLocalMap(withOutConTr: withOutConTr),
      MessageTable.columnAttachment: jsonEncode(fileSource.toMap())
    };
  }
}
