import 'dart:convert';

import 'package:chopper/chopper.dart';

import '../../../../v_chat_sdk_core.dart';
import '../base_message/base_message.dart';
import '../db_tables_name.dart';
import 'location_message_data.dart';

class VLocationMessage extends VBaseMessage {
  VLocationMessageData data;

  VLocationMessage({
    required super.id,
    required super.senderId,
    required super.messageStatus,
    required super.senderName,
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
    required this.data,
  });

  VLocationMessage.fromLocalMap(super.map)
      : data = VLocationMessageData.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String)
              as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  VLocationMessage.fromRemoteMap(super.map)
      : data = VLocationMessageData.fromMap(
          map['msgAtt'] as Map<String, dynamic>,
        ),
        super.fromRemoteMap();

  @override
  Map<String, dynamic> toLocalMap({
    bool withOutConTr = false,
  }) {
    return {
      ...super.toLocalMap(withOutConTr: withOutConTr),
      MessageTable.columnAttachment: jsonEncode(data.toMap()),
    };
  }

  VLocationMessage.buildMessage({
    required super.roomId,
    required this.data,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          messageType: MessageType.location,
          content: AppConstants.thisContentIsLocation,
        );

  @override
  List<PartValue> toListOfPartValue() {
    return [
      ...super.toListOfPartValue(),
      PartValue(
        'attachment',
        jsonEncode(data.toMap()),
      ),
    ];
  }
// @override
// Map<String, dynamic> toRemoteMap() {
//   return {...super.toRemoteMap(), 'msgAtt': data.toMap()};
// }
}
