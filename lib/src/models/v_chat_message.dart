import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../enums/message_type.dart';
import '../utils/helpers/helpers.dart';
import 'v_chat_message_attachment.dart';

@immutable
class VChatMessage {
  final int id;
  final MessageType messageType;
  final VChatMessageAttachment? messageAttachment;
  final int createdAt;
  final int updatedAt;
  final String content;
  final int senderId;
  final String senderName;
  final String senderImageThumb;
  final int roomId;
  final String createdAtString;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const VChatMessage({
    required this.id,
    required this.messageType,
    required this.messageAttachment,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderImageThumb,
    required this.roomId,
    required this.createdAtString,
  });

  VChatMessage copyWith({
    int? id,
    MessageType? messageType,
    VChatMessageAttachment? messageAttachment,
    int? createdAt,
    int? updatedAt,
    String? content,
    int? senderId,
    String? senderName,
    String? senderImageThumb,
    int? roomId,
    String? createdAtString,
  }) {
    return VChatMessage(
      id: id ?? this.id,
      messageType: messageType ?? this.messageType,
      messageAttachment: messageAttachment ?? this.messageAttachment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImageThumb: senderImageThumb ?? this.senderImageThumb,
      roomId: roomId ?? this.roomId,
      createdAtString: createdAtString ?? this.createdAtString,
    );
  }

  @override
  String toString() {
    return 'Message{id: $id, messageType: $messageType, messageAttachment: $messageAttachment, createdAt: $createdAt, updatedAt: $updatedAt, content: $content, senderId: $senderId, senderName: $senderName, senderImageThumb: $senderImageThumb, roomId: $roomId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          messageType == other.messageType &&
          messageAttachment == other.messageAttachment &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          content == other.content &&
          senderId == other.senderId &&
          senderName == other.senderName &&
          senderImageThumb == other.senderImageThumb &&
          roomId == other.roomId);

  @override
  int get hashCode =>
      id.hashCode ^
      messageType.hashCode ^
      messageAttachment.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      content.hashCode ^
      senderId.hashCode ^
      senderName.hashCode ^
      senderImageThumb.hashCode ^
      roomId.hashCode;

  factory VChatMessage.fromMap(dynamic map) {
    const MessageType messageType = MessageType.text;
    final createdAtLocal = Helpers.getLocalTime(map['createdAt'] as int);
    final updatedAtLocal = Helpers.getLocalTime(map['updatedAt'] as int);
    return VChatMessage(
      id: map['_id'] as int,
      messageType: messageType.enumType(map['messageType']),
      messageAttachment:
          map['messageAttachment'] == null ? null : VChatMessageAttachment.fromMap(map['messageAttachment']),
      createdAt: createdAtLocal.millisecondsSinceEpoch,
      createdAtString: DateFormat.jm().format(createdAtLocal),
      updatedAt: updatedAtLocal.millisecondsSinceEpoch,
      content: map['content'] as String,
      senderId: map['senderId'] as int,
      senderName: map['senderName'] as String,
      senderImageThumb: map['senderImageThumb'] as String,
      roomId: map['roomId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'messageType': messageType.inString,
      'messageAttachment': messageAttachment == null ? null : messageAttachment!.toMap(),
      'content': content,
      'roomId': roomId,
    } as Map<String, dynamic>;
  }

  Map<String, dynamic> toLocalMap() {
    // ignore: unnecessary_cast
    return {
      '_id': id,
      'messageType': messageType.inString,
      'messageAttachment': messageAttachment == null ? null : messageAttachment!.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'senderImageThumb': senderImageThumb,
      'roomId': roomId,
      'createdAtString': createdAtString,
    } as Map<String, dynamic>;
  }

//</editor-fold>
}
