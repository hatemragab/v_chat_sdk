import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:intl/intl.dart';
import 'package:objectid/objectid.dart';
import 'package:uuid/uuid.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../local_db/tables/message_table.dart';
import '../../../utils/api_constants.dart';
import '../core/message_factory.dart';

abstract class VBaseMessage {
  VBaseMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderImageThumb,
    required this.platform,
    required this.roomId,
    required this.content,
    required this.messageType,
    required this.localId,
    required this.createdAt,
    required this.updatedAt,
    required this.messageStatus,
    required this.replyTo,
    required this.seenAt,
    required this.deliveredAt,
    required this.forwardId,
    required this.deletedAt,
    required this.parentBroadcastId,
    required this.isStared,
  });

  ///id will be changed if message get from remote
  String id;

  /// sender data
  String senderId;
  String senderName;
  VFullUrlModel senderImageThumb;

  ///which pla-from this message send through
  final String platform;
  final String roomId;

  ///message text from server
  final String content;
  MessageType messageType;

  ///serverConfirm,error,sending
  MessageEmitStatus messageStatus;

  /// only will have value if this message reply to another
  VBaseMessage? replyTo;
  String? seenAt;
  String? deliveredAt;

  ///forward from message id
  String? forwardId;

  /// when message deleted from all
  String? deletedAt;

  ///if message send through broadcast
  String? parentBroadcastId;

  /// unique message id that is used to unique the message access all messages
  /// it good because the message id will changed
  String localId;

  ///when the message was send
  String createdAt;
  final String updatedAt;

  /// is user intent to delete this message
  bool isDeleted = false;
  bool isStared;

  VBaseMessage.fromRemoteMap(Map<String, dynamic> map)
      : id = map['_id'] as String,
        senderId = map['sId'] as String,
        senderName = map['sName'] as String,
        senderImageThumb = VFullUrlModel(map['sImg'] as String),
        platform = map['plm'] as String,
        forwardId = map['forId'] as String?,
        roomId = map['rId'] as String,
        isStared = map['isStared'] == null ? false : map['isStared'] as bool,
        content = map['c'] as String,
        messageType = MessageType.values.byName(map['mT'] as String),
        replyTo = map['rTo'] == null
            ? null
            : MessageFactory.createBaseMessage(
                map['rTo'] as Map<String, dynamic>,
              ),
        seenAt = map['sAt'] as String?,
        deliveredAt = map['dAt'] as String?,
        deletedAt = map['dltAt'] as String?,
        parentBroadcastId = map['pBId'] as String?,
        localId = map['lId'] as String,
        createdAt = map['createdAt'] as String,
        messageStatus = MessageEmitStatus.serverConfirm,
        updatedAt = map['updatedAt'] as String;

  /// from local
  VBaseMessage.fromLocalMap(Map<String, dynamic> map)
      : id = map[MessageTable.columnId] as String,
        senderId = map[MessageTable.columnSenderId] as String,
        senderName = map[MessageTable.columnSenderName] as String,
        senderImageThumb =
            VFullUrlModel(map[MessageTable.columnSenderImageThumb] as String),
        platform = map[MessageTable.columnPlatform] as String,
        roomId = map[MessageTable.columnRoomId] as String,
        isStared = (map[MessageTable.columnIsStar] as int) == 1,
        content = map[MessageTable.columnContent] as String,
        seenAt = map[MessageTable.columnSeenAt] as String?,
        replyTo = map[MessageTable.columnReplyTo] == null
            ? null
            : MessageFactory.createBaseMessage(
                jsonDecode(map[MessageTable.columnReplyTo] as String)
                    as Map<String, dynamic>,
              ),
        deliveredAt = map[MessageTable.columnDeliveredAt] as String?,
        forwardId = map[MessageTable.columnForwardId] as String?,
        deletedAt = map[MessageTable.columnAllDeletedAt] as String?,
        parentBroadcastId =
            map[MessageTable.columnParentBroadcastId] as String?,
        localId = map[MessageTable.columnLocalId] as String,
        createdAt = map[MessageTable.columnCreatedAt] as String,
        updatedAt = map[MessageTable.columnUpdatedAt] as String,
        messageStatus = MessageEmitStatus.values
            .byName(map[MessageTable.columnMessageEmitStatus] as String),
        messageType = MessageType.values
            .byName(map[MessageTable.columnMessageType] as String);

  Map<String, Object?> toLocalMap() {
    final map = {
      MessageTable.columnId: id,
      MessageTable.columnSenderId: senderId,
      MessageTable.columnSenderName: senderName,
      MessageTable.columnSenderImageThumb: senderImageThumb.originalUrl,
      MessageTable.columnPlatform: platform,
      MessageTable.columnRoomId: roomId,
      MessageTable.columnIsStar: isStared ? 1 : 0,
      MessageTable.columnContent: content,
      MessageTable.columnMessageType: messageType.name,
      MessageTable.columnReplyTo:
          replyTo == null ? null : jsonEncode(replyTo!.toLocalMap()),
      MessageTable.columnSeenAt: seenAt,
      MessageTable.columnDeliveredAt: deliveredAt,
      MessageTable.columnForwardId: forwardId,
      MessageTable.columnAllDeletedAt: deletedAt,
      MessageTable.columnMessageEmitStatus: messageStatus.name,
      MessageTable.columnParentBroadcastId: parentBroadcastId,
      MessageTable.columnLocalId: localId,
      MessageTable.columnCreatedAt: createdAt,
      MessageTable.columnUpdatedAt: updatedAt,
    };
    return map;
  }

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('content', content),
      PartValue('localId', localId),
      PartValue('forwardLocalId', forwardId),
      PartValue(
        'messageType',
        messageType.name,
      ),
      PartValue(
        'replyToLocalId',
        replyTo == null || isForward ? null : replyTo!.localId,
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      other is VBaseMessage && localId == other.localId && id == other.id;

  @override
  int get hashCode => localId.hashCode ^ id.hashCode;

  bool get isMeSender {
    return AppConstants.myProfile.baseUser.vChatId == senderId;
  }

  ///Some Getters
  bool get isForward => forwardId != null;

  String get lastMessageTimeString =>
      DateFormat.jm().format(DateTime.parse(createdAt).toLocal());

  DateTime get createdAtDate => DateTime.parse(createdAt).toLocal();

  DateTime? get seenAtDate =>
      seenAt == null ? null : DateTime.parse(seenAt!).toLocal();

  DateTime? get deliveredAtDate =>
      deliveredAt == null ? null : DateTime.parse(deliveredAt!).toLocal();

  DateTime? get deletedAtDate =>
      deletedAt == null ? null : DateTime.parse(deletedAt!).toLocal();

  bool get isFromBroadcast => parentBroadcastId != null;

  bool get isContainReply => replyTo != null;

  String get getTextTrans {
    return AppConstants.getMessageBody(this);
  }

  @override
  String toString() {
    return 'BaseMessage{id: $id, senderId: $senderId, senderName: $senderName, senderImageThumb: $senderImageThumb, platform: $platform, roomId: $roomId, content: $content, messageType: $messageType, messageStatus: $messageStatus, replyTo: $replyTo, seenAt: $seenAt, deliveredAt: $deliveredAt, forwardId: $forwardId, deletedAt: $deletedAt, parentBroadcastId: $parentBroadcastId,  localId: $localId, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, isStared: $isStared}';
  }

  VBaseMessage.buildMessage({
    required this.content,
    required this.roomId,
    required this.messageType,
    this.forwardId,
    String? broadcastId,
    this.replyTo,
  })  : id = ObjectId().hexString,
        localId = const Uuid().v4(),
        platform = VPlatforms.currentPlatform,
        createdAt = DateTime.now().toLocal().toIso8601String(),
        updatedAt = DateTime.now().toLocal().toIso8601String(),
        senderId = AppConstants.myProfile.baseUser.vChatId,
        isStared = false,
        senderName = AppConstants.myProfile.baseUser.fullName,
        senderImageThumb =
            AppConstants.myProfile.baseUser.userImages.smallImage,
        messageStatus = MessageEmitStatus.sending,
        parentBroadcastId = broadcastId,
        deletedAt = null,
        seenAt = null,
        deliveredAt = null;

  VBaseMessage.buildFakeMessage({
    required this.content,
    required this.messageType,
    required this.messageStatus,
    this.forwardId,
    String? broadcastId,
    this.replyTo,
  })  : id = ObjectId().hexString,
        localId = const Uuid().v4(),
        roomId = "roomId $content",
        platform = VPlatforms.currentPlatform,
        createdAt = DateTime.now().toLocal().toIso8601String(),
        updatedAt = DateTime.now().toLocal().toIso8601String(),
        senderId = AppConstants.fakeMyProfile.baseUser.vChatId,
        isStared = false,
        senderName = AppConstants.fakeMyProfile.baseUser.fullName,
        senderImageThumb =
            AppConstants.fakeMyProfile.baseUser.userImages.smallImage,
        parentBroadcastId = broadcastId,
        deletedAt = null,
        seenAt = null,
        deliveredAt = null;

  Map<String, Object?> toRemoteMap() {
    return {
      "_id": id,
      "sId": senderId,
      "sName": senderName,
      "sImg": senderImageThumb.originalUrl,
      "plm": platform,
      "mT": messageType.name,
      "rId": roomId,
      "c": content,
      "isStared": isStared,
      "sAt": seenAt,
      "rTo": replyTo == null ? null : (replyTo!).toRemoteMap(),
      "lId": localId,
      "dAt": deliveredAt,
      "forId": forwardId,
      "dltAt": deletedAt,
      "pBId": parentBroadcastId,
      "createdAt": createdAt,
      "updatedAt": updatedAt
    };
  }
}
