import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageAppBarStateModel {
  DateTime? lastSeenAt;
  String roomTitle;
  String roomId;
  String? peerIdentifier;
  String roomImage;
  VSocketRoomTypingModel typingModel;
  VRoomType roomType;
  bool isOnline;
  bool isSearching;

  MessageAppBarStateModel._({
    required this.roomTitle,
    required this.roomId,
    required this.peerIdentifier,
    required this.roomImage,
    required this.typingModel,
    required this.roomType,
    required this.isOnline,
    required this.isSearching,
  });

  factory MessageAppBarStateModel.fromVRoom(VRoom room) {
    return MessageAppBarStateModel._(
      roomId: room.id,
      typingModel: room.typingStatus,
      isOnline: room.isThereBlock ? false : room.isOnline,
      roomImage: room.thumbImage,
      roomTitle: room.title,
      roomType: room.roomType,
      isSearching: false,
      peerIdentifier: room.peerIdentifier,
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
