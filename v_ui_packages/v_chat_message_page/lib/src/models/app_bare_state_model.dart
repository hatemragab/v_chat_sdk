// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageAppBarStateModel {
  DateTime? lastSeenAt;
  String roomTitle;
  String roomId;
  String? peerIdentifier;
  String roomImage;
  VSocketRoomTypingModel typingModel;
  VRoomType roomType;
  bool isOnline;
  bool isSearching;
  int? memberCount;

  MessageAppBarStateModel._({
    required this.roomTitle,
    required this.roomId,
    required this.peerIdentifier,
    required this.roomImage,
    required this.typingModel,
    required this.roomType,
    required this.isOnline,
    required this.isSearching,
  });

  factory MessageAppBarStateModel.fromVRoom(VRoom room) {
    return MessageAppBarStateModel._(
      roomId: room.id,
      typingModel: room.typingStatus,
      isOnline: room.isOnline,
      roomImage: room.thumbImage,
      roomTitle: room.title,
      roomType: room.roomType,
      isSearching: false,
      peerIdentifier: room.peerIdentifier,
    );
  }

  String? typingText(BuildContext context) {
    if (roomType.isGroup) {
      return typingModel.inGroupText(context);
    } else if (roomType.isSingle) {
      return typingModel.inSingleText(context);
    }
    return null;
  }
}
