// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/utils/api_constants.dart';

/// Data model class for messages delivered event from WebSocket server
class VSocketOnDeliverMessagesModel {
  /// Room ID where message is delivered
  final String roomId;

  /// User ID who delivered message
  final String userId;

  /// The date and time when message is delivered in ISO 8601 format with UTC timezone
  final String date;

  const VSocketOnDeliverMessagesModel({
    required this.roomId,
    required this.userId,
    required this.date,
  });

  /// Returns true if the message is delivered by the current authenticated user
  bool get isMe => VAppConstants.myId == userId;

  /// Returns the local date and time when message is delivered
  DateTime get localDate => DateTime.parse(date).toLocal();

  @override
  String toString() {
    return 'OnEnterRoomModel{roomId: $roomId, userId: $userId, date: $date}';
  }

  /// Returns a [Map] representation of this object
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'userId': userId,
      'date': date,
    };
  }

  /// Creates an instance of this object from the given [map]
  factory VSocketOnDeliverMessagesModel.fromMap(Map<String, dynamic> map) {
    return VSocketOnDeliverMessagesModel(
      roomId: map['roomId'] as String,
      userId: map['userId'] as String,
      date: map['date'] as String,
    );
  }
}
