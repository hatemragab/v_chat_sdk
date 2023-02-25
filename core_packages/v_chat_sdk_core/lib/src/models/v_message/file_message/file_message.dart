// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/src/utils/v_message_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VFileMessage extends VBaseMessage {
  final VMessageFileData data;

  VFileMessage({
    required super.id,
    required super.sIdentifier,
    required super.senderId,
    required super.senderName,
    required super.senderImageThumb,
    required super.contentTr,
    required super.platform,
    required super.roomId,
    required super.content,
    required super.emitStatus,
    required super.messageType,
    required super.localId,
    required super.isEncrypted,
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
          content: VMessageConstants.thisContentIsFile,
          messageType: VMessageType.file,
          isEncrypted: false,
        );
}
