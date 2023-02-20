import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';

class VCallHistory {
  final VIdentifierUser peerUser;
  final VMessageCallStatus callStatus;
  final String roomId;
  final bool withVideo;
  final String? endAt;
  final String startAt;

//<editor-fold desc="Data Methods">
  const VCallHistory({
    required this.peerUser,
    required this.callStatus,
    required this.roomId,
    required this.withVideo,
    this.endAt,
    required this.startAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VCallHistory &&
          runtimeType == other.runtimeType &&
          peerUser == other.peerUser &&
          callStatus == other.callStatus &&
          roomId == other.roomId &&
          withVideo == other.withVideo &&
          endAt == other.endAt &&
          startAt == other.startAt);

  @override
  int get hashCode =>
      peerUser.hashCode ^
      callStatus.hashCode ^
      roomId.hashCode ^
      withVideo.hashCode ^
      endAt.hashCode ^
      startAt.hashCode;

  @override
  String toString() {
    return 'VCallHistory{ peerUser: $peerUser, callStatus: $callStatus, roomId: $roomId, withVideo: $withVideo, endAt: $endAt, startAt: $startAt,}';
  }

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

  factory VCallHistory.fromMap(Map<String, dynamic> map) {
    return VCallHistory(
      peerUser:
          VIdentifierUser.fromMap(map['peerUser'] as Map<String, dynamic>),
      callStatus: VMessageCallStatus.values.byName(map['callStatus'] as String),
      roomId: map['roomId'] as String,
      withVideo: map['withVideo'] as bool,
      endAt: map['endAt'] as String?,
      startAt: map['startAt'] as String,
    );
  }

//</editor-fold>
}
