import 'package:flutter/foundation.dart';

enum RoomType { single, groupChat }

extension RoomTypeEnum on RoomType {
  String get inString => describeEnum(this);
}
