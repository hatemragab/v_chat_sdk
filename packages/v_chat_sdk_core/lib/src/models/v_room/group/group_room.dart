import '../base_room.dart';

class GroupRoom extends BaseRoom {
  GroupRoom({
    required super.id,
    required super.title,
    required super.enTitle,
    required super.thumbImage,
    required super.transTo,
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

  GroupRoom.fromMap(super.map) : super.fromMap();

  GroupRoom.fromLocalMap(super.map) : super.fromLocalMap();
}
