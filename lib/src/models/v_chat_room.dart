import 'package:get/get.dart';

import '../enums/room_type.dart';
import '../enums/room_typing_type.dart';
import 'group_chat_setting.dart';
import 'v_chat_message.dart';
import 'v_chat_room_typing.dart';

class VchatRoom {
  final int id;
  final RoomType roomType;
  RxInt blockerId;
  final int createdAt;
  int updatedAt;
  final int creatorId;
  RxInt isMute;
  RxList<int> lastMessageSeenBy;
  final RxInt isOnline;
  final String title;
  final String thumbImage;
  final GroupChatSetting? groupSetting;
  final int? ifSinglePeerId;
  Rx<VChatMessage> lastMessage;
  Rx<VChatRoomTyping> typingStatus = VChatRoomTyping(status: RoomTypingType.stop).obs;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  VchatRoom({
    required this.id,
    required this.roomType,
    required this.blockerId,
    required this.groupSetting,
    required this.createdAt,
    required this.updatedAt,
    required this.creatorId,
    required this.isMute,
    required this.lastMessageSeenBy,
    required this.isOnline,
    required this.title,
    required this.thumbImage,
    required this.ifSinglePeerId,
    required this.lastMessage,
  });

  // Room copyWith({
  //   int? id,
  //   RoomType? roomType,
  //   RxInt? blockerId,
  //   int? createdAt,
  //   int? updatedAt,
  //   int? creatorId,
  //   int? isMute,
  //   RxList<int>? lastMessageSeenBy,
  //   RxInt? isOnline,
  //   String? title,
  //   String? thumbImage,
  //   int? ifSinglePeerId,
  //   Rx<Message>? lastMessage,
  // }) {
  //   return Room(
  //     id: id ?? this.id,
  //     roomType: roomType ?? this.roomType,
  //     blockerId: blockerId ?? this.blockerId,
  //     createdAt: createdAt ?? this.createdAt,
  //     updatedAt: updatedAt ?? this.updatedAt,
  //     creatorId: creatorId ?? this.creatorId,
  //     isMute: isMute ?? this.isMute,
  //     lastMessageSeenBy: lastMessageSeenBy ?? this.lastMessageSeenBy,
  //     isOnline: isOnline ?? this.isOnline,
  //     title: title ?? this.title,
  //     thumbImage: thumbImage ?? this.thumbImage,
  //     ifSinglePeerId: ifSinglePeerId ?? this.ifSinglePeerId,
  //     lastMessage: lastMessage ?? this.lastMessage,
  //   );
  // }

  @override
  String toString() {
    return 'Room{id: $id, roomType: $roomType, blockerId: $blockerId, createdAt: $createdAt, updatedAt: $updatedAt, creatorId: $creatorId, isMute: $isMute, isLastMessageSeenByMe: $lastMessageSeenBy, isOnline: $isOnline, title: $title, thumbImage: $thumbImage, ifSinglePeerId: $ifSinglePeerId, lastMessage: $lastMessage}';
  }

  factory VchatRoom.fromMap(dynamic map) {
    return VchatRoom(
      id: map['_id'] as int,
      roomType: map['roomType'] == RoomType.single.inString
          ? RoomType.single
          : RoomType.groupChat,
      blockerId: (map['blockerId'] as int).obs,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      groupSetting: map['setting'] == null
          ? null
          : GroupChatSetting.fromMap(map['groupSetting']),
      creatorId: map['creatorId'] as int,
      isMute: (map['isMute'] as int).obs,
      lastMessageSeenBy:
          (map['lastMessageSeenBy'] as List).map((e) => e as int).toList().obs,
      isOnline: (map['isOnline'] as int).obs,
      title: map['title'] as String,
      thumbImage: map['thumbImage'] as String,
      ifSinglePeerId: map['peerId'] as int?,
      lastMessage: VChatMessage.fromMap(map['lastMessage']).obs,
    );
  }

  Map<String, dynamic> toLocalMap() {
    // ignore: unnecessary_cast
    return {
      '_id': id,
      'roomType': roomType.inString,
      'blockerId': blockerId.value,
      'createdAt': createdAt,
      'groupSetting': groupSetting == null ? null : groupSetting!.toMap(),
      'updatedAt': updatedAt,
      'creatorId': creatorId,
      'isMute': isMute.value,
      'lastMessageSeenBy': lastMessageSeenBy,
      'isOnline': 0,
      'title': title,
      'thumbImage': thumbImage,
      'peerId': ifSinglePeerId,
      'lastMessage': lastMessage.value.toLocalMap(),
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
