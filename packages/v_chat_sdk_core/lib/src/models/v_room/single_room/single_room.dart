import '../base_room.dart';

class SingleRoom extends BaseRoom {
  SingleRoom({
    required super.id,
    required super.title,
    required super.enTitle,
    required super.thumbImage,
    required super.transTo,
    required super.isArchived,
    required super.roomType,
    required super.isMuted,
    required super.unReadCount,
    required super.lastMessage,
    required super.isDeleted,
    required super.createdAt,
    required super.isOnline,
    required super.peerId,
    required super.blockerId,
    required super.typingStatus,
    required super.nickName,
  });

  SingleRoom.fromMap(super.map) : super.fromMap();

  SingleRoom.empty() : super.empty();

  @override
  String toString() {
    return 'SingleRoom{isOnline: $isOnline, typingStatus: $typingStatus, nickName: $nickName, isMuted: $isMuted, peerId: $peerId, blockerId: $blockerId} => Base is {id: $id, title: $title, enTitle: $enTitle, thumbImage: $thumbImage, roomType: $roomType, transTo: $transTo, isArchived: $isArchived, unReadCount: $unReadCount, lastMessage: $lastMessage, isDeleted: $isDeleted, createdAt: $createdAt, isSelected: $isSelected,';
  }

  SingleRoom.fromLocalMap(super.map) : super.fromLocalMap();
}
