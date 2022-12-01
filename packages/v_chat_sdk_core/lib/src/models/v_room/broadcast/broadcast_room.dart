import '../base_room.dart';

class VBroadcastRoom extends VBaseRoom {
  VBroadcastRoom({
    required super.id,
    required super.title,
    required super.enTitle,
    required super.thumbImage,
    required super.isArchived,
    required super.roomType,
    required super.unReadCount,
    required super.lastMessage,
    required super.isDeleted,
    required super.isMuted,
    required super.createdAt,
    required super.isOnline,
    required super.peerId,
    required super.blockerId,
    required super.typingStatus,
    required super.nickName,
  });

  VBroadcastRoom.fromMap(super.map) : super.fromMap();

  VBroadcastRoom.fromLocalMap(super.map) : super.fromLocalMap();
}
