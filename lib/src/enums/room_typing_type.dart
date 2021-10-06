import 'package:flutter/foundation.dart';

enum RoomTypingType{
 stop,typing,recording
}
extension RoomTypingTypeEnum on RoomTypingType {
  String get inString => describeEnum(this);

  RoomTypingType enumType(String type) {
    if (type == RoomTypingType.stop.inString) {
      return RoomTypingType.stop;
    } else if (type == RoomTypingType.typing.inString) {
      return RoomTypingType.typing;
    } else if (type == RoomTypingType.recording.inString) {
      return RoomTypingType.recording;
    } else {
      throw ("V_CHAT_SAY =>>>> type in RoomTypingType is ${type.toString()}");
    }
  }
}