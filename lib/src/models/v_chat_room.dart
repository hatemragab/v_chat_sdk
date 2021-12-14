import 'package:flutter/cupertino.dart';
import '../enums/room_type.dart';
import '../enums/room_typing_type.dart';
import 'v_chat_group_chat_info.dart';
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

  final int isOnline;
  final String title;
  final String thumbImage;
  final String? ifSinglePeerId;
  final String? ifSinglePeerEmail;
  final VChatGroupChatInfo? groupSetting;
  final VChatMessage lastMessage;
  final VChatRoomTyping typingStatus;
  final int roomMembersCount;
  final int unReadCount;
  final int ifPeerReadMyLastMessage;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const VChatRoom({
    required this.id,
    required this.roomType,
    required this.blockerId,
    required this.groupSetting,
    required this.updatedAt,
    required this.creatorId,
    required this.isMute,
    required this.ifPeerReadMyLastMessage,
    required this.isOnline,
    required this.title,
    required this.thumbImage,
    required this.ifSinglePeerId,
    required this.lastMessage,
    required this.typingStatus,
    required this.ifSinglePeerEmail,
    required this.roomMembersCount,
    required this.unReadCount,
  });

  @override
  String toString() {
    return 'VChatRoom{id: $id, roomType: $roomType, blockerId: $blockerId, updatedAt: $updatedAt, creatorId: $creatorId, isMute: $isMute, isOnline: $isOnline, title: $title, thumbImage: $thumbImage, ifSinglePeerId: $ifSinglePeerId, ifSinglePeerEmail: $ifSinglePeerEmail, groupSetting: $groupSetting, lastMessage: $lastMessage, typingStatus: $typingStatus, roomMembersCount: $roomMembersCount, unReadCount: $unReadCount}';
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
          isOnline == other.isOnline &&
          title == other.title &&
          thumbImage == other.thumbImage &&
          ifSinglePeerId == other.ifSinglePeerId &&
          ifSinglePeerEmail == other.ifSinglePeerEmail &&
          groupSetting == other.groupSetting &&
          lastMessage == other.lastMessage &&
          typingStatus == other.typingStatus &&
          roomMembersCount == other.roomMembersCount &&
          unReadCount == other.unReadCount;

  @override
  int get hashCode =>
      id.hashCode ^
      roomType.hashCode ^
      blockerId.hashCode ^
      updatedAt.hashCode ^
      creatorId.hashCode ^
      isMute.hashCode ^
      isOnline.hashCode ^
      title.hashCode ^
      thumbImage.hashCode ^
      ifSinglePeerId.hashCode ^
      ifSinglePeerEmail.hashCode ^
      groupSetting.hashCode ^
      lastMessage.hashCode ^
      typingStatus.hashCode ^
      roomMembersCount.hashCode ^
      unReadCount.hashCode;

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
          : VChatGroupChatInfo.fromMap(map['groupSetting']),
      creatorId: map['creatorId'] as String,
      ifPeerReadMyLastMessage: map['ifPeerReadMyLastMessage'] as int,
      isMute: (map['isMute'] as int),
      isOnline: (map['isOnline'] as int),
      title: map['title'] as String,
      thumbImage: map['thumbImage'] as String,
      ifSinglePeerId: map['peerId'] as String?,
      lastMessage: VChatMessage.fromMap(map['lastMessage']),
      unReadCount: map['unReadCount'] as int,
      roomMembersCount: map['roomMembersCount'] as int,
      typingStatus: VChatRoomTyping(status: RoomTypingType.stop),
      ifSinglePeerEmail: map['peerEmail'] as String?,
    );
  }

  Map<String, dynamic> toLocalMap() {
    // ignore: unnecessary_cast
    return {
      '_id': id,
      'roomType': roomType.inString,
      'blockerId': blockerId,
      'updatedAt': updatedAt,
      'groupSetting':
          roomType == RoomType.groupChat ? groupSetting!.toMap() : null,
      'creatorId': creatorId,
      'isMute': isMute,
      'isOnline': 0,
      'title': title,
      'ifPeerReadMyLastMessage': ifPeerReadMyLastMessage,
      'thumbImage': thumbImage,
      'peerId': ifSinglePeerId,
      'lastMessage': lastMessage.toLocalMap(),
      'unReadCount': unReadCount,
      'roomMembersCount': roomMembersCount,
      'peerEmail': ifSinglePeerEmail,
    } as Map<String, dynamic>;
  }

  VChatRoom copyWith({
    String? id,
    RoomType? roomType,
    String? blockerId,
    int? updatedAt,
    String? creatorId,
    int? isMute,
    int? isOnline,
    int? ifPeerReadMyLastMessage,
    String? title,
    String? thumbImage,
    String? ifSinglePeerId,
    String? ifSinglePeerEmail,
    VChatGroupChatInfo? groupSetting,
    VChatMessage? lastMessage,
    VChatRoomTyping? typingStatus,
    int? roomMembersCount,
    int? unReadCount,
  }) {
    return VChatRoom(
      id: id ?? this.id,
      roomType: roomType ?? this.roomType,
      blockerId: blockerId ?? this.blockerId,
      updatedAt: updatedAt ?? this.updatedAt,
      creatorId: creatorId ?? this.creatorId,
      ifPeerReadMyLastMessage:
          ifPeerReadMyLastMessage ?? this.ifPeerReadMyLastMessage,
      isMute: isMute ?? this.isMute,
      isOnline: isOnline ?? this.isOnline,
      title: title ?? this.title,
      thumbImage: thumbImage ?? this.thumbImage,
      ifSinglePeerId: ifSinglePeerId ?? this.ifSinglePeerId,
      ifSinglePeerEmail: ifSinglePeerEmail ?? this.ifSinglePeerEmail,
      groupSetting: groupSetting ?? this.groupSetting,
      lastMessage: lastMessage ?? this.lastMessage,
      typingStatus: typingStatus ?? this.typingStatus,
      roomMembersCount: roomMembersCount ?? this.roomMembersCount,
      unReadCount: unReadCount ?? this.unReadCount,
    );
  }
//</editor-fold>

}
