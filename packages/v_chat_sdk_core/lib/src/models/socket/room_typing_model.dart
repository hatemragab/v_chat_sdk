import '../../../v_chat_sdk_core.dart';

class RoomTypingModel {
  final RoomTypingEnum status;
  final String roomId;
  final String userId;
  final String name;

  bool get isMe => AppConstants.myId == userId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const RoomTypingModel({
    required this.status,
    required this.roomId,
    required this.name,
    required this.userId,
  });

  static const RoomTypingModel offline = RoomTypingModel(
    name: "offline",
    roomId: "offline",
    status: RoomTypingEnum.stop,
    userId: "offline",
  );

  RoomTypingModel copyWith({
    String? roomId,
    String? userId,
    String? name,
    RoomTypingEnum? status,
  }) {
    return RoomTypingModel(
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  bool get isTyping => status == RoomTypingEnum.typing;

  bool get isRecording => status == RoomTypingEnum.recording;

  bool get isStopTyping => status == RoomTypingEnum.stop;

  @override
  String toString() {
    return 'RoomTyping{status: $status, roomId: $roomId, name: $name userId:$userId}';
  }

  String? get inSingleText {
    return _statusInText;
  }

  String? get _statusInText {
    //todo fix trnas
    switch (status) {
      case RoomTypingEnum.stop:
        return null;
      case RoomTypingEnum.typing:
        return "S.current.typing";
      case RoomTypingEnum.recording:
        return "S.current.recording";
    }
  }

  String? get inGroupText {
    if (_statusInText == null) return null;
    return "$name ${_statusInText!}";
  }

  factory RoomTypingModel.fromMap(Map<String, dynamic> map) {
    return RoomTypingModel(
      status: RoomTypingEnum.values.byName(map['status'] as String),
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
