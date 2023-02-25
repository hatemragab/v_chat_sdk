// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:random_string/random_string.dart';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VTextMessage extends VBaseMessage {
  VTextMessage({
    required super.id,
    required super.sIdentifier,
    required super.senderId,
    required super.senderName,
    required super.senderImageThumb,
    required super.emitStatus,
    required super.isEncrypted,
    required super.contentTr,
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
  });

  VTextMessage.buildMessage({
    required super.content,
    required super.isEncrypted,
    required super.roomId,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(messageType: VMessageType.text);

  VTextMessage.fromRemoteMap(super.map) : super.fromRemoteMap();

  VTextMessage.buildFakeMessage({
    required int index,
    VMessageEmitStatus messageStatus = VMessageEmitStatus.serverConfirm,
  }) : super.buildFakeMessage(
          content: randomString(index * 25),
          messageType: VMessageType.text,
          emitStatus: messageStatus,
        );

  VTextMessage.fromLocalMap(super.map) : super.fromLocalMap();

  @override
  bool operator ==(Object other) =>
      other is VBaseMessage && localId == other.localId;

  @override
  int get hashCode => localId.hashCode;
}
