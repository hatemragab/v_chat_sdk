import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';

import '../../../v_chat_sdk_core.dart';
import '../../local_db/tables/room_table.dart';
import '../socket/room_typing_model.dart';
import '../v_message/core/message_factory.dart';

abstract class VBaseRoom {
  final String id;
  String title;
  String enTitle;
  VFullUrlModel thumbImage;
  RoomType roomType;
  bool isArchived;
  int unReadCount;
  VBaseMessage lastMessage;
  bool isDeleted;
  @protected
  final DateTime createdAt;
  bool isSelected = false;
  bool isMuted;
  bool isOnline;
  RoomTypingModel typingStatus;
  String? nickName;
  final String? peerId;
  String? blockerId;

  VBaseRoom({
    required this.id,
    required this.title,
    required this.enTitle,
    required this.roomType,
    required this.thumbImage,
    required this.isArchived,
    required this.unReadCount,
    required this.lastMessage,
    required this.isDeleted,
    required this.createdAt,
    required this.isMuted,
    this.isOnline = false,
    this.blockerId,
    required this.peerId,
    required this.nickName,
    this.typingStatus = RoomTypingModel.offline,
  });

  VBaseRoom.empty()
      : id = "",
        title = "",
        thumbImage = VFullUrlModel("empty!.png"),
        isArchived = false,
        roomType = RoomType.s,
        createdAt = DateTime.now(),
        enTitle = "",
        unReadCount = 0,
        isMuted = false,
        isDeleted = false,
        nickName = null,
        typingStatus = RoomTypingModel.offline,
        isOnline = false,
        blockerId = null,
        peerId = null,
        lastMessage = VEmptyMessage();

  VBaseRoom.fromMap(Map<String, dynamic> map)
      : id = map['rId'] as String,
        title = map['t'] as String,
        thumbImage = VFullUrlModel(map['img'] as String),
        isArchived = map['isA'] as bool,
        roomType = RoomType.values.byName(map['rT'] as String),
        createdAt = DateTime.parse(map['createdAt'] as String),
        enTitle = removeDiacritics(map['t'] as String),
        unReadCount = map['uC'] as int,
        isMuted = map['isM'] as bool,
        isDeleted = map['isD'] as bool,
        nickName = null,
        typingStatus = RoomTypingModel.offline,
        isOnline = false,
        blockerId = map['bId'] as String?,
        peerId = map['pId'] as String?,
        lastMessage = (map['messages'] as List).isEmpty
            ? VEmptyMessage()
            : MessageFactory.createBaseMessage(
                (map['messages'] as List).first as Map<String, dynamic>,
              );

  VBaseRoom.fromLocalMap(Map<String, dynamic> map)
      : id = map[RoomTable.columnId] as String,
        roomType =
            RoomType.values.byName(map[RoomTable.columnRoomType] as String),
        title = map[RoomTable.columnTitle] as String,
        thumbImage = VFullUrlModel(map[RoomTable.columnThumbImage] as String),
        isArchived = (map[RoomTable.columnIsArchived] as int) == 1,
        createdAt = DateTime.parse(map[RoomTable.columnCreatedAt] as String),
        enTitle = map[RoomTable.columnEnTitle] as String,
        unReadCount = map[RoomTable.columnUnReadCount] as int,
        isMuted = (map[RoomTable.columnIsMuted] as int) == 1,
        isDeleted = (map[RoomTable.columnIsDeleted] as int) == 1,
        nickName = map[RoomTable.columnNickName] as String?,
        typingStatus = RoomTypingModel.fromMap(
          jsonDecode(map[RoomTable.columnRoomTyping] as String)
              as Map<String, dynamic>,
        ),
        isOnline = (map[RoomTable.columnIsOnline] as int) == 1,
        blockerId = map[RoomTable.columnBlockerId] as String?,
        peerId = map[RoomTable.columnPeerId] as String?,
        lastMessage = MessageFactory.createBaseMessage(map);

  Map<String, dynamic> toLocalMap() {
    return {
      RoomTable.columnId: id,
      RoomTable.columnTitle: title,
      RoomTable.columnThumbImage: thumbImage.originalUrl,
      RoomTable.columnEnTitle: enTitle,
      RoomTable.columnRoomType: roomType.name,
      RoomTable.columnIsArchived: isArchived ? 1 : 0,
      RoomTable.columnIsDeleted: isDeleted ? 1 : 0,
      RoomTable.columnUnReadCount: unReadCount,
      RoomTable.columnCreatedAt: createdAt.toUtc().toIso8601String(),
      RoomTable.columnIsMuted: isMuted ? 1 : 0,
      RoomTable.columnIsOnline: isOnline ? 1 : 0,
      RoomTable.columnRoomTyping: jsonEncode(typingStatus.toMap()),
      RoomTable.columnNickName: nickName,
      RoomTable.columnPeerId: peerId,
      RoomTable.columnBlockerId: blockerId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VBaseRoom &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode => id.hashCode;

  DateTime get lastMessageTime => lastMessage.createdAtDate;

  @override
  String toString() {
    return 'BaseRoom{id: $id, title: $title, enTitle: $enTitle, thumbImage: $thumbImage, roomType: $roomType, isArchived: $isArchived, unReadCount: $unReadCount, lastMessage: $lastMessage, isDeleted: $isDeleted, createdAt: $createdAt, isSelected: $isSelected,}';
  }

  ///getters
  bool get isRoomMuted {
    final current = this;
    if (current is VSingleRoom) {
      return current.isMuted;
    }
    if (current is VGroupRoom) {
      return current.isMuted;
    }
    return false;
  }

  String? get roomTypingText {
    final current = this;
    if (current is VSingleRoom) {
      return current.typingStatus.inSingleText;
    }
    if (current is VGroupRoom) {
      return current.typingStatus.inGroupText;
    }
    return null;
  }

  bool get isRoomOnline {
    final current = this;
    if (current is VSingleRoom) {
      return current.isOnline;
    }
    return false;
  }
}
