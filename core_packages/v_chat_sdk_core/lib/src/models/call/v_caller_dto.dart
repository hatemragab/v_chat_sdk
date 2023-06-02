// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// Represents a Data Transfer Object (DTO) for a caller in the VChat application.
class VCallerDto {
  final bool isVideoEnable;
  final String roomId;
  final String peerName;
  final String peerImage;

  /// Create a new [VCallerDto].
  ///
  /// - [isVideoEnable]: A boolean indicating if the video is enabled for the call.
  /// - [roomId]: The unique identifier of the room where the call is taking place.
  /// - [peerName]: The name of the peer user in the call.
  /// - [peerImage]: The display picture of the peer user.
  const VCallerDto({
    required this.isVideoEnable,
    required this.roomId,
    required this.peerName,
    required this.peerImage,
  });

  /// Compares two [VCallerDto] instances for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCallerDto &&
        isVideoEnable == other.isVideoEnable &&
        roomId == other.roomId &&
        peerName == other.peerName &&
        peerImage == other.peerImage;
  }

  /// Returns a hash code for this instance.
  @override
  int get hashCode => Object.hash(isVideoEnable, roomId, peerName, peerImage);

  /// Returns a string representation of this instance.
  @override
  String toString() {
    return 'VCallerDto{ isVideoEnable: $isVideoEnable, roomId: $roomId, peerName: $peerName, peerImage: $peerImage,}';
  }

  /// Returns a new [VCallerDto] instance with updated values.
  VCallerDto copyWith({
    bool? isVideoEnable,
    String? roomId,
    String? peerName,
    String? peerImage,
  }) {
    return VCallerDto(
      isVideoEnable: isVideoEnable ?? this.isVideoEnable,
      roomId: roomId ?? this.roomId,
      peerName: peerName ?? this.peerName,
      peerImage: peerImage ?? this.peerImage,
    );
  }

  /// Converts this [VCallerDto] instance to a Map.
  Map<String, dynamic> toMap() {
    return {
      'isVideoEnable': isVideoEnable,
      'roomId': roomId,
      'peerName': peerName,
      'peerImage': peerImage,
    };
  }

  /// Creates a new [VCallerDto] instance from a Map.
  factory VCallerDto.fromMap(Map<String, dynamic> map) {
    return VCallerDto(
      isVideoEnable: map['isVideoEnable'] as bool,
      roomId: map['roomId'] as String,
      peerName: map['peerName'] as String,
      peerImage: map['peerImage'] as String,
    );
  }
}
