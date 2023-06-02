// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';

/// Represents a record of a single video call in the VChat application.
class VCallHistory {
  final VIdentifierUser peerUser;
  final VMessageCallStatus callStatus;
  final String roomId;
  final bool withVideo;
  final String? endAt;
  final String startAt;

  /// Create a new [VCallHistory].
  ///
  /// - [peerUser]: The user on the other end of the call.
  /// - [callStatus]: The status of the call (e.g., answered, missed, rejected).
  /// - [roomId]: The unique identifier of the room where the call took place.
  /// - [withVideo]: Indicates whether the call was a video call.
  /// - [endAt]: The time when the call ended.
  /// - [startAt]: The time when the call started.
  const VCallHistory({
    required this.peerUser,
    required this.callStatus,
    required this.roomId,
    required this.withVideo,
    this.endAt,
    required this.startAt,
  });

  /// Compares two [VCallHistory] instances for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCallHistory &&
        peerUser == other.peerUser &&
        callStatus == other.callStatus &&
        roomId == other.roomId &&
        withVideo == other.withVideo &&
        endAt == other.endAt &&
        startAt == other.startAt;
  }

  /// Returns a hash code for this instance.
  @override
  int get hashCode =>
      peerUser.hashCode ^
      callStatus.hashCode ^
      roomId.hashCode ^
      withVideo.hashCode ^
      endAt.hashCode ^
      startAt.hashCode;

  /// Returns a string representation of this instance.
  @override
  String toString() {
    return 'VCallHistory{ peerUser: $peerUser, callStatus: $callStatus, roomId: $roomId, withVideo: $withVideo, endAt: $endAt, startAt: $startAt,}';
  }

  /// Returns a new [VCallHistory] instance with updated values.
  VCallHistory copyWith({
    VIdentifierUser? peerUser,
    VMessageCallStatus? callStatus,
    String? roomId,
    bool? withVideo,
    String? endAt,
    String? startAt,
  }) {
    return VCallHistory(
      peerUser: peerUser ?? this.peerUser,
      callStatus: callStatus ?? this.callStatus,
      roomId: roomId ?? this.roomId,
      withVideo: withVideo ?? this.withVideo,
      endAt: endAt ?? this.endAt,
      startAt: startAt ?? this.startAt,
    );
  }

  /// Converts this [VCallHistory] instance to a Map.
  Map<String, dynamic> toMap() {
    return {
      'peerUser': peerUser.toMap(),
      'callStatus': callStatus.name,
      'roomId': roomId,
      'withVideo': withVideo,
      'endAt': endAt,
      'startAt': startAt,
    };
  }

  /// Creates a new [VCallHistory] instance from a Map.
  factory VCallHistory.fromMap(Map<String, dynamic> map) {
    return VCallHistory(
      peerUser:
          VIdentifierUser.fromMap(map['peerUser'] as Map<String, dynamic>),
      callStatus: VMessageCallStatus.values
          .firstWhere((e) => e.name == map['callStatus']),
      roomId: map['roomId'] as String,
      withVideo: map['withVideo'] as bool,
      endAt: map['endAt'] as String?,
      startAt: map['startAt'] as String,
    );
  }
}
