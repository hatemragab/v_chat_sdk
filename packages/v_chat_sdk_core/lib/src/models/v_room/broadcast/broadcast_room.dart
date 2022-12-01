import '../base_room.dart';

class BroadcastRoom extends BaseRoom {
  BroadcastRoom({
    required super.id,
    required super.title,
    required super.enTitle,
    required super.thumbImage,
    required super.transTo,
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

  BroadcastRoom.fromMap(super.map) : super.fromMap();

  BroadcastRoom.fromLocalMap(super.map) : super.fromLocalMap();
}
