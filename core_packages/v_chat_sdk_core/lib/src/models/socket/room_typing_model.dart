import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VSocketRoomTypingModel {
  final VRoomTypingEnum status;
  final String roomId;
  final String userId;
  final String name;

  bool get isMe => VAppConstants.myId == userId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const VSocketRoomTypingModel({
    required this.status,
    required this.roomId,
    required this.name,
    required this.userId,
  });

  static const VSocketRoomTypingModel offline = VSocketRoomTypingModel(
    name: "offline",
    roomId: "offline",
    status: VRoomTypingEnum.stop,
    userId: "offline",
  );
  static const VSocketRoomTypingModel typing = VSocketRoomTypingModel(
    name: "fake typing",
    roomId: "fake",
    status: VRoomTypingEnum.typing,
    userId: "fake",
  );
  static const VSocketRoomTypingModel recoding = VSocketRoomTypingModel(
    name: "fake recoding",
    roomId: "fake",
    status: VRoomTypingEnum.recording,
    userId: "fake",
  );

  VSocketRoomTypingModel copyWith({
    String? roomId,
    String? userId,
    String? name,
    VRoomTypingEnum? status,
  }) {
    return VSocketRoomTypingModel(
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  bool get isTyping => status == VRoomTypingEnum.typing;

  bool get isRecording => status == VRoomTypingEnum.recording;

  bool get isStopTyping => status == VRoomTypingEnum.stop;

  @override
  String toString() {
    return 'RoomTyping{status: $status, roomId: $roomId, name: $name userId:$userId}';
  }

  String? inSingleText(BuildContext context) {
    return _statusInText(context);
  }

  String? _statusInText(BuildContext context) {
    switch (status) {
      case VRoomTypingEnum.stop:
        return null;
      case VRoomTypingEnum.typing:
        return VTrans.of(context).labels.typing;

      case VRoomTypingEnum.recording:
        return VTrans.of(context).labels.recording;
    }
  }

  String? inGroupText(BuildContext context) {
    if (_statusInText(context) == null) return null;
    return "$name ${_statusInText(context)!}";
  }

  factory VSocketRoomTypingModel.fromMap(Map<String, dynamic> map) {
    return VSocketRoomTypingModel(
      status: VRoomTypingEnum.values.byName(map['status'] as String),
      name: map['name'] as String,
      userId: map['userId'] as String,
      roomId: map['roomId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'userId': roomId,
      'name': name,
      'roomId': roomId,
    };
  }

//</editor-fold>
}
