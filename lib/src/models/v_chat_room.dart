import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../enums/room_type.dart';
import '../enums/room_typing_type.dart';
import 'group_chat_setting.dart';
import 'v_chat_message.dart';
import 'v_chat_room_typing.dart';

@immutable
class VChatRoom {
  final int id;
  final RoomType roomType;
  final int blockerId;
  final int createdAt;
  final int updatedAt;
  final int creatorId;
  final int isMute;
  final List<int> lastMessageSeenBy;
  final int isOnline;
  final String title;
  final String thumbImage;
  final GroupChatSetting? groupSetting;
  final int? ifSinglePeerId;
  final VChatMessage lastMessage;
  final VChatRoomTyping typingStatus;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const VChatRoom({
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
    required this.typingStatus,
  });

  @override
  String toString() {
    return 'Room{id: $id, roomType: $roomType, blockerId: $blockerId, createdAt: $createdAt, updatedAt: $updatedAt, creatorId: $creatorId, isMute: $isMute, isLastMessageSeenByMe: $lastMessageSeenBy, isOnline: $isOnline, title: $title, thumbImage: $thumbImage, ifSinglePeerId: $ifSinglePeerId, lastMessage: $lastMessage}';
  }

  factory VChatRoom.fromMap(dynamic map) {
    return VChatRoom(
        id: map['_id'] as int,
        roomType: map['roomType'] == RoomType.single.inString
            ? RoomType.single
            : RoomType.groupChat,
        blockerId: (map['blockerId'] as int),
        createdAt: map['createdAt'] as int,
        updatedAt: (map['updatedAt'] as int),
        groupSetting: map['setting'] == null
            ? null
            : GroupChatSetting.fromMap(map['groupSetting']),
        creatorId: map['creatorId'] as int,
        isMute: (map['isMute'] as int),
        lastMessageSeenBy: (map['lastMessageSeenBy'] as List)
            .map((e) => e as int)
            .toList()
            .obs,
        isOnline: (map['isOnline'] as int),
        title: map['title'] as String,
        thumbImage: map['thumbImage'] as String,
        ifSinglePeerId: map['peerId'] as int?,
        lastMessage: VChatMessage.fromMap(map['lastMessage']),
        typingStatus: VChatRoomTyping(status: RoomTypingType.stop));
  }

  Map<String, dynamic> toLocalMap() {
    // ignore: unnecessary_cast
    return {
      '_id': id,
      'roomType': roomType.inString,
      'blockerId': blockerId,
      'createdAt': createdAt,
      'groupSetting': groupSetting == null ? null : groupSetting!.toMap(),
      'updatedAt': updatedAt,
      'creatorId': creatorId,
      'isMute': isMute,
      'lastMessageSeenBy': lastMessageSeenBy,
      'isOnline': 0,
      'title': title,
      'thumbImage': thumbImage,
      'peerId': ifSinglePeerId,
      'lastMessage': lastMessage.toLocalMap(),
    } as Map<String, dynamic>;
  }

  VChatRoom copyWith({
    int? id,
    RoomType? roomType,
    int? blockerId,
    int? createdAt,
    int? updatedAt,
    int? creatorId,
    int? isMute,
    List<int>? lastMessageSeenBy,
    int? isOnline,
    String? title,
    String? thumbImage,
    GroupChatSetting? groupSetting,
    int? ifSinglePeerId,
    VChatMessage? lastMessage,
    VChatRoomTyping? typingStatus,
  }) {
    return VChatRoom(
      id: id ?? this.id,
      roomType: roomType ?? this.roomType,
      blockerId: blockerId ?? this.blockerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      creatorId: creatorId ?? this.creatorId,
      isMute: isMute ?? this.isMute,
      lastMessageSeenBy: lastMessageSeenBy ?? this.lastMessageSeenBy,
      isOnline: isOnline ?? this.isOnline,
      title: title ?? this.title,
      thumbImage: thumbImage ?? this.thumbImage,
      groupSetting: groupSetting ?? this.groupSetting,
      ifSinglePeerId: ifSinglePeerId ?? this.ifSinglePeerId,
      lastMessage: lastMessage ?? this.lastMessage,
      typingStatus: typingStatus ?? this.typingStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VChatRoom &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          roomType == other.roomType &&
          blockerId == other.blockerId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          creatorId == other.creatorId &&
          isMute == other.isMute &&
          lastMessageSeenBy == other.lastMessageSeenBy &&
          isOnline == other.isOnline &&
          title == other.title &&
          thumbImage == other.thumbImage &&
          groupSetting == other.groupSetting &&
          ifSinglePeerId == other.ifSinglePeerId &&
          lastMessage == other.lastMessage &&
          typingStatus == other.typingStatus;

  @override
  int get hashCode =>
      id.hashCode ^
      roomType.hashCode ^
      blockerId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      creatorId.hashCode ^
      isMute.hashCode ^
      lastMessageSeenBy.hashCode ^
      isOnline.hashCode ^
      title.hashCode ^
      thumbImage.hashCode ^
      groupSetting.hashCode ^
      ifSinglePeerId.hashCode ^
      lastMessage.hashCode ^
      typingStatus.hashCode;

//</editor-fold>

}
