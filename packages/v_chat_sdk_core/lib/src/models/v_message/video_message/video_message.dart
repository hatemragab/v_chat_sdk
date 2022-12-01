import 'dart:convert';

import 'package:chopper/chopper.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../types/message_video_data.dart';
import '../base_message/base_message.dart';
import '../db_tables_name.dart';

class VVideoMessage extends VBaseMessage {
  final MessageVideoData fileSource;

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
    required super.contentTr,
    required this.fileSource,
  });

  VVideoMessage.fromRemoteMap(super.map)
      : fileSource = MessageVideoData.fromMap(
          map['msgAtt'] as Map<String, dynamic>,
        ),
        super.fromRemoteMap();

  VVideoMessage.fromLocalMap(super.map)
      : fileSource = MessageVideoData.fromMap(
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
  Map<String, dynamic> toLocalMap({
    bool withOutConTr = false,
  }) {
    return {
      ...super.toLocalMap(withOutConTr: withOutConTr),
      MessageTable.columnAttachment: jsonEncode(fileSource.toMap())
    };
  }
}
