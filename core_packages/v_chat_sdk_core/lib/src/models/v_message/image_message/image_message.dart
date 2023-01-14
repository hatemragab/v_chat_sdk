import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../local_db/tables/message_table.dart';
import '../../../utils/api_constants.dart';

class VImageMessage extends VBaseMessage {
  final VMessageImageData data;

  VImageMessage({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.isEncrypted,
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
    required this.data,
  });

  VImageMessage.fromRemoteMap(super.map)
      : data = VMessageImageData.fromMap(
          map['msgAtt'] as Map<String, dynamic>,
        ),
        super.fromRemoteMap();

  VImageMessage.fromLocalMap(super.map)
      : data = VMessageImageData.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String)
              as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  @override
  Map<String, dynamic> toRemoteMap() {
    return {...super.toRemoteMap(), 'msgAtt': data.toMap()};
  }

  VImageMessage.buildMessage({
    required super.roomId,
    required this.data,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          isEncrypted: false,
          content: VAppConstants.thisContentIsImage,
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
    return 'ImageMessage{fileSource: $data}';
  }

  @override
  Map<String, dynamic> toLocalMap() {
    return {
      ...super.toLocalMap(),
      MessageTable.columnAttachment: jsonEncode(data.toMap())
    };
  }

  VImageMessage.buildFakeMessage({
    required int high,
    required int width,
  })  : data = VMessageImageData.fromFakeData(
          width: width,
          high: high,
        ),
        super.buildFakeMessage(
          content: "Fake this is fake image message",
          messageType: MessageType.image,
          emitStatus: MessageEmitStatus.serverConfirm,
        );
}
