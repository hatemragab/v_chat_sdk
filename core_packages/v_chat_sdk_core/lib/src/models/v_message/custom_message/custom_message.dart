// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VCustomMessage extends VBaseMessage {
  final VCustomMsgData data;

  VCustomMessage({
    required super.id,
    required super.sIdentifier,
    required super.senderId,
    required super.senderName,
    required super.contentTr,
    required super.emitStatus,
    required super.isEncrypted,
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
  VCustomMessage.buildMessage({
    required super.roomId,
    required super.isEncrypted,
    required this.data,
    super.forwardId,
    required super.content,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          messageType: VMessageType.custom,
        );
  VCustomMessage.fromRemoteMap(super.map)
      : data = VCustomMsgData.fromMap(map['msgAtt'] as Map<String, dynamic>),
        super.fromRemoteMap();

  VCustomMessage.fromLocalMap(super.map)
      : data = VCustomMsgData.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String)
              as Map<String, dynamic>,
        ),
        super.fromLocalMap();

  // @override
  // Map<String, dynamic> toRemoteMap() {
  //   return {...super.toRemoteMap(), 'msgAtt': infoAtt.toMap()};
  // }

  @override
  Map<String, dynamic> toLocalMap() {
    return {
      ...super.toLocalMap(),
      MessageTable.columnAttachment: jsonEncode(data.toMap())
    };
  }
}
