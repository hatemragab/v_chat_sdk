// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VCallerDto {
  final bool isVideoEnable;
  final String roomId;
  final String peerName;
  final String peerImage;

//<editor-fold desc="Data Methods">
  const VCallerDto({
    required this.isVideoEnable,
    required this.roomId,
    required this.peerName,
    required this.peerImage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VCallerDto &&
          runtimeType == other.runtimeType &&
          isVideoEnable == other.isVideoEnable &&
          roomId == other.roomId &&
          peerName == other.peerName &&
          peerImage == other.peerImage);

  @override
  int get hashCode =>
      isVideoEnable.hashCode ^
      roomId.hashCode ^
      peerName.hashCode ^
      peerImage.hashCode;

  @override
  String toString() {
    return 'VCallerDto{ isVideoEnable: $isVideoEnable, roomId: $roomId, peerName: $peerName, peerImage: $peerImage,}';
  }

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

  Map<String, dynamic> toMap() {
    return {
      'isVideoEnable': isVideoEnable,
      'roomId': roomId,
      'peerName': peerName,
      'peerImage': peerImage,
    };
  }

  factory VCallerDto.fromMap(Map<String, dynamic> map) {
    return VCallerDto(
      isVideoEnable: map['isVideoEnable'] as bool,
      roomId: map['roomId'] as String,
      peerName: map['peerName'] as String,
      peerImage: map['peerImage'] as String,
    );
  }

//</editor-fold>
}
