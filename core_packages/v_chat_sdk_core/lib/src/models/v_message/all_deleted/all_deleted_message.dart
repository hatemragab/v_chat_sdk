// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/v_message/base_message/v_base_message.dart';

class VAllDeletedMessage extends VBaseMessage {
  VAllDeletedMessage({
    required super.id,
    required super.sIdentifier,

    required super.senderId,
    required super.senderName,
    required super.emitStatus,
    required super.senderImageThumb,
    required super.platform,
    required super.roomId,
    required super.content,
    required super.messageType,
    required super.localId,
    required super.createdAt,
    required super.updatedAt,
    required super.isEncrypted,
    required super.replyTo,
    required super.seenAt,
    required super.deliveredAt,
    required super.forwardId,
    required super.deletedAt,
    required super.parentBroadcastId,
    required super.isStared,
  });

  VAllDeletedMessage.fromRemoteMap(super.map) : super.fromRemoteMap();

  VAllDeletedMessage.fromLocalMap(super.map) : super.fromLocalMap();
}
