import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class AppBareState {
  final VRoom _room;
  DateTime? lastSeenAt;
  int? memberCount;

  AppBareState(
    this._room, [
    this.lastSeenAt,
    this.memberCount,
  ]);

  VSocketRoomTypingModel get typingModel => _room.typingStatus;

  bool get isOnline => _room.isOnline;

  String get roomTitle => _room.title;

  String get roomId => _room.id;

  RoomType get roomType => _room.roomType;

  String? get typingText => _room.roomTypingText;

  VFullUrlModel get roomImage => _room.thumbImage;
}
