// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// A class representing the details of an accepted call event.
class VOnAcceptCall {
  /// The unique identifier of the room where the call took place.
  final String roomId;

  /// The unique identifier of the call.
  final String meetId;

  /// The peer's answer to the call offer as a Map of dynamic values.
  final Map<String, dynamic>? peerAnswer;

  /// Creates a new instance of [VOnAcceptCall].
  const VOnAcceptCall({
    required this.roomId,
    required this.meetId,
    required this.peerAnswer,
  });

  /// Converts this object to a map of dynamic values.
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'meetId': meetId,
      'peerAnswer': peerAnswer,
    };
  }

  /// Creates a new instance of [VOnAcceptCall] from a map of dynamic values.
  factory VOnAcceptCall.fromMap(Map<String, dynamic> map) {
    return VOnAcceptCall(
      roomId: map['roomId'] as String,
      meetId: map['meetId'] as String,
      peerAnswer: map['peerAnswer'] as Map<String, dynamic>?,
    );
  }
}
