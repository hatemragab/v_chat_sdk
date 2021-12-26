import 'package:flutter/foundation.dart';

enum RoomTypingType { stop, typing, recording }

extension RoomTypingTypeEnum on RoomTypingType {
  String get inString => describeEnum(this);

  RoomTypingType enumType(String type) {
    return RoomTypingType.values.firstWhere((e) => e.inString == type);
  }
}
