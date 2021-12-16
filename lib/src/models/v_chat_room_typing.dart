import '../enums/room_typing_type.dart';

class VChatRoomTyping {
  RoomTypingType status;
  String? roomId;
  String? name;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  VChatRoomTyping({
    required this.status,
    this.roomId,
    this.name,
  });

  VChatRoomTyping copyWith({
    RoomTypingType? status,
    String? roomId,
    String? name,
  }) {
    return VChatRoomTyping(
      status: status ?? this.status,
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'RoomTyping{status: $status, roomId: $roomId, name: $name}';
  }

  factory VChatRoomTyping.fromMap(Map<String, dynamic> map) {
    const t = RoomTypingType.stop;
    return VChatRoomTyping(
      status: t.enumType(map['status'] as String),
      name: map['name'] as String?,
      roomId: map['roomId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {'status': status.inString, 'name': name, 'roomId': roomId}
        as Map<String, dynamic>;
  }

//</editor-fold>

}
