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
  final String id;
  final bool withVideo;
  final String? endAt;
  final String startAt;

  /// Create a new [VCallHistory].
  ///
  /// - [peerUser]: The user on the other end of the call.
  /// - [callStatus]: The status of the call (e.g., answered, missed, rejected).
  /// - [roomId]: The unique peerId of the room where the call took place.
  /// - [withVideo]: Indicates whether the call was a video call.
  /// - [endAt]: The time when the call ended.
  /// - [startAt]: The time when the call started.
  const VCallHistory({
    required this.peerUser,
    required this.callStatus,
    required this.roomId,
    required this.id,
    required this.withVideo,
    this.endAt,
    required this.startAt,
  });

  String? get duration {
    if (endAtDate == null) return null;
    return endAtDate!.difference(startAtDate).inMinutes.toString();
  }

  DateTime get startAtDate => DateTime.parse(startAt).toLocal();

  DateTime? get endAtDate =>
      endAt == null ? null : DateTime.parse(endAt!).toLocal();

  /// Returns a string representation of this instance.
  @override
  String toString() {
    return 'VCallHistory{ peerUser: $peerUser, callStatus: $callStatus, roomId: $roomId, withVideo: $withVideo, endAt: $endAt, startAt: $startAt,}';
  }

  /// Converts this [VCallHistory] instance to a Map.
  Map<String, dynamic> toMap() {
    return {
      'peerUser': peerUser.toMap(),
      'callStatus': callStatus.name,
      'roomId': roomId,
      'withVideo': withVideo,
      '_id': id,
      'endAt': endAt,
      'createdAt': startAt,
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
      id: map['_id'] as String,
      withVideo: map['withVideo'] as bool,
      endAt: map['endAt'] as String?,
      startAt: map['createdAt'] as String,
    );
  }
}
