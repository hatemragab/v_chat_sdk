import 'dart:convert';

import '../base_message/base_message.dart';
import '../db_tables_name.dart';
import 'msg_info_att.dart';

class VInfoMessage extends VBaseMessage {
  final MsgInfoAtt infoAtt;

  VInfoMessage({
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
    required this.infoAtt,
  });

  VInfoMessage.fromRemoteMap(super.map)
      : infoAtt = MsgInfoAtt.fromMap(map['msgAtt'] as Map<String, dynamic>),
        super.fromRemoteMap();

  VInfoMessage.fromLocalMap(super.map)
      : infoAtt = MsgInfoAtt.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String)
              as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  // @override
  // Map<String, dynamic> toRemoteMap() {
  //   return {...super.toRemoteMap(), 'msgAtt': infoAtt.toMap()};
  // }

  @override
  Map<String, dynamic> toLocalMap({
    bool withOutConTr = false,
  }) {
    return {
      ...super.toLocalMap(withOutConTr: withOutConTr),
      MessageTable.columnAttachment: jsonEncode(infoAtt.toMap())
    };
  }
}
