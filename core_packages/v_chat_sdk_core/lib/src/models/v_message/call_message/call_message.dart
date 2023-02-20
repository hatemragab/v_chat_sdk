// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/src/models/v_message/base_message/v_base_message.dart';
import 'package:v_chat_sdk_core/src/models/v_message/call_message/msg_call_att.dart';

class VCallMessage extends VBaseMessage {
  final VMsgCallAtt data;

  VCallMessage({
    required super.id,
    required super.sIdentifier,
    required super.senderId,
    required super.senderName,
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

  VCallMessage.fromRemoteMap(super.map)
      : data = VMsgCallAtt.fromMap(map['msgAtt'] as Map<String, dynamic>),
        super.fromRemoteMap();

  VCallMessage.fromLocalMap(super.map)
      : data = VMsgCallAtt.fromMap(
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
      ...super.toLocalMap(),
      MessageTable.columnAttachment: jsonEncode(data.toMap())
    };
  }
}
