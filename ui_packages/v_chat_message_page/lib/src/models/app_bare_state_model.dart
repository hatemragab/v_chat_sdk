import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class MessageAppBarStateModel {
  DateTime? lastSeenAt;
  int? memberCount;
  String roomTitle;
  String roomId;
  VFullUrlModel roomImage;
  VSocketRoomTypingModel typingModel;
  VRoomType roomType;
  bool isOnline;

  MessageAppBarStateModel._({
    this.lastSeenAt,
    this.memberCount,
    required this.roomTitle,
    required this.roomId,
    required this.roomImage,
    required this.typingModel,
    required this.roomType,
    required this.isOnline,
  });

  factory MessageAppBarStateModel.fromVRoom(VRoom room) {
    return MessageAppBarStateModel._(
      roomId: room.id,
      typingModel: room.typingStatus,
      isOnline: room.isOnline,
      roomImage: room.thumbImage,
      roomTitle: room.title,
      roomType: room.roomType,
    );
  }

  String? get typingText {
    if (roomType.isGroup) {
      return typingModel.inGroupText;
    } else if (roomType.isSingle) {
      return typingModel.inSingleText;
    }
    return null;
  }
}
