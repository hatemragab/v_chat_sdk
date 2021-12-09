import 'package:flutter/cupertino.dart';
import '../enums/room_type.dart';
import '../enums/room_typing_type.dart';
import 'group_chat_setting.dart';
import 'v_chat_message.dart';
import 'v_chat_room_typing.dart';

@immutable
class VChatRoom {
  final String id;
  final RoomType roomType;
  final String? blockerId;
  final int updatedAt;
  final String creatorId;
  final int isMute;
  final List<String> lastMessageSeenBy;
  final int isOnline;
  final String title;
  final String thumbImage;
  final GroupChatSetting? groupSetting;
  final String? ifSinglePeerId;
  final VChatMessage lastMessage;
  final VChatRoomTyping typingStatus;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const VChatRoom({
    required this.id,
    required this.roomType,
    required this.blockerId,
    required this.groupSetting,
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
    return 'Room{id: $id, roomType: $roomType, blockerId: $blockerId, updatedAt: $updatedAt, creatorId: $creatorId, isMute: $isMute, isLastMessageSeenByMe: $lastMessageSeenBy, isOnline: $isOnline, title: $title, thumbImage: $thumbImage, ifSinglePeerId: $ifSinglePeerId, lastMessage: $lastMessage}';
  }

  factory VChatRoom.fromMap(dynamic map) {
    return VChatRoom(
        id: map['_id'] as String,
        roomType: map['roomType'] == RoomType.single.inString
            ? RoomType.single
            : RoomType.groupChat,
        blockerId: map['blockerId'] as String?,
        updatedAt: (map['updatedAt'] as int),
        groupSetting: map['groupSetting'] == null
            ? null
            : GroupChatSetting.fromMap(map['groupSetting']),
        creatorId: map['creatorId'] as String,
        isMute: (map['isMute'] as int),
        lastMessageSeenBy:
            (map['lastMessageSeenBy'] as List).map((e) => e as String).toList(),
        isOnline: (map['isOnline'] as int),
        title: map['title'] as String,
        thumbImage: map['thumbImage'] as String,
        ifSinglePeerId: map['peerId'] as String?,
        lastMessage: VChatMessage.fromMap(map['lastMessage']),
        typingStatus: VChatRoomTyping(status: RoomTypingType.stop));
  }

  Map<String, dynamic> toLocalMap() {
    // ignore: unnecessary_cast
    return {
      '_id': id,
      'roomType': roomType.inString,
      'blockerId': blockerId,
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
    String? id,
    RoomType? roomType,
    String? blockerId,
    int? updatedAt,
    String? creatorId,
    int? isMute,
    List<String>? lastMessageSeenBy,
    int? isOnline,
    String? title,
    String? thumbImage,
    GroupChatSetting? groupSetting,
    String? ifSinglePeerId,
    VChatMessage? lastMessage,
    VChatRoomTyping? typingStatus,
  }) {
    return VChatRoom(
      id: id ?? this.id,
      roomType: roomType ?? this.roomType,
      blockerId: blockerId ?? this.blockerId,
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
