import '../base_room.dart';

class VGroupRoom extends VBaseRoom {
  VGroupRoom({
    required super.id,
    required super.title,
    required super.enTitle,
    required super.thumbImage,
    required super.isArchived,
    required super.isMuted,
    required super.unReadCount,
    required super.lastMessage,
    required super.roomType,
    required super.isDeleted,
    required super.createdAt,
    required super.isOnline,
    required super.peerId,
    required super.blockerId,
    required super.typingStatus,
    required super.nickName,
  });

  VGroupRoom.fromMap(super.map) : super.fromMap();

  VGroupRoom.fromLocalMap(super.map) : super.fromLocalMap();
}
