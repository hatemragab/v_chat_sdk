import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../local_db/tables/message_table.dart';
import '../../../utils/api_constants.dart';

class VVideoMessage extends VBaseMessage {
  final VMessageVideoData fileSource;

  VVideoMessage({
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
    required this.fileSource,
  });

  VVideoMessage.fromRemoteMap(super.map)
      : fileSource = VMessageVideoData.fromMap(
          map['msgAtt'] as Map<String, dynamic>,
        ),
        super.fromRemoteMap();

  VVideoMessage.fromLocalMap(super.map)
      : fileSource = VMessageVideoData.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String)
              as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  // @override
  // Map<String, dynamic> toRemoteMap() {
  //   return {...super.toRemoteMap(), 'msgAtt': fileUrlAttachment.toMap()};
  // }
  VVideoMessage.buildMessage({
    required super.roomId,
    required this.fileSource,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          messageType: MessageType.video,
          content: AppConstants.thisContentIsVideo,
        );

  @override
  List<PartValue> toListOfPartValue() {
    return [
      ...super.toListOfPartValue(),
      PartValue(
        'attachment',
        jsonEncode(fileSource.toMap()),
      ),
    ];
  }

  @override
  Map<String, dynamic> toLocalMap() {
    return {
      ...super.toLocalMap(),
      MessageTable.columnAttachment: jsonEncode(fileSource.toMap())
    };
  }
}
