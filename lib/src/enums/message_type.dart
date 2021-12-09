import 'package:flutter/foundation.dart';

enum MessageType {
  text,
  voice,
  image,
  video,
  file,
  reply,
  allDeleted,
  location,
  create,
  join,
  leave,
  upgrade,
  downgrade,
  forward
}

extension MessageTypeEnum on MessageType {
  String get inString => describeEnum(this);

  MessageType enumType(String type) {
    return MessageType.values.firstWhere((e) => e.inString == type);
  }
}
