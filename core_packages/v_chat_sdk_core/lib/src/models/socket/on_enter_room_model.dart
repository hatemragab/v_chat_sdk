// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/utils/api_constants.dart';

/// Model class for Socket event when a user has seen a room
class VSocketOnRoomSeenModel {
  /// The id of the room that the user has seen
  final String roomId;

  /// The id of the user who has seen the room
  final String userId;

  /// The date and time when the user has seen the room in ISO 8601 format
  final String date;

  /// Constructor for creating a new instance of [VSocketOnRoomSeenModel]
  const VSocketOnRoomSeenModel({
    required this.roomId,
    required this.userId,
    required this.date,
  });

  /// Returns the local date and time when the user has seen the room
  DateTime get localDate => DateTime.parse(date).toLocal();

  /// Returns a string representation of the [VSocketOnRoomSeenModel] instance
  @override
  String toString() {
    return 'OnEnterRoomModel{roomId: $roomId, userId: $userId, date: $date}';
  }

  /// Returns a map representation of the [VSocketOnRoomSeenModel] instance
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'userId': userId,
      'date': date,
    };
  }

  /// Returns `true` if the [VSocketOnRoomSeenModel] instance belongs to the current user, or `false` otherwise
  bool get isMe => VAppConstants.myId == userId;

  /// Factory constructor for creating an instance of [VSocketOnRoomSeenModel] from a map
  factory VSocketOnRoomSeenModel.fromMap(Map<String, dynamic> map) {
    return VSocketOnRoomSeenModel(
      roomId: map['roomId'] as String,
      userId: map['userId'] as String,
      date: map['date'] as String,
    );
  }
}
