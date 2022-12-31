import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../local_db/tables/message_table.dart';
import '../../../utils/api_constants.dart';

class VFileMessage extends VBaseMessage {
  final VMessageFileData data;

  VFileMessage({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.senderImageThumb,
    required super.platform,
    required super.roomId,
    required super.content,
    required super.messageStatus,
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

  VFileMessage.fromRemoteMap(super.map)
      : data = VMessageFileData(
          fileSource: VPlatformFileSource.fromMap(
            map['msgAtt'] as Map<String, dynamic>,
          ),
        ),
        super.fromRemoteMap();

  VFileMessage.fromLocalMap(super.map)
      : data = VMessageFileData(
          fileSource: VPlatformFileSource.fromMap(
            jsonDecode(map[MessageTable.columnAttachment] as String)
                as Map<String, dynamic>,
          ),
        ),
        super.fromLocalMap();

  // @override
  // Map<String, dynamic> toRemoteMap() {
  //   return {...super.toRemoteMap(), 'msgAtt': fileUrlAttachment.toMap()};
  // }

  @override
  Map<String, dynamic> toLocalMap({
    bool withOutConTr = false,
  }) {
    return {
      ...super.toLocalMap(),
      MessageTable.columnAttachment: jsonEncode(data.toMap())
    };
  }

  @override
  List<PartValue> toListOfPartValue() {
    return [
      ...super.toListOfPartValue(),
    ];
  }

  VFileMessage.buildMessage({
    required super.roomId,
    required this.data,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          content: VAppConstants.thisContentIsFile,
          messageType: MessageType.file,
        );
}
