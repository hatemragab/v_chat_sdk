import 'package:flutter/foundation.dart';

enum MessageType { text, voice, image, video, file, reply, info,allDeleted }

extension MessageTypeEnum on MessageType {
  String get inString => describeEnum(this);

  MessageType enumType(String type) {
    if (type == MessageType.text.inString) {
      return MessageType.text;
    } else if (type == MessageType.info.inString) {
      return MessageType.info;
    } else if (type == MessageType.voice.inString) {
      return MessageType.voice;
    } else if (type == MessageType.image.inString) {
      return MessageType.image;
    } else if (type == MessageType.video.inString) {
      return MessageType.video;
    } else if (type == MessageType.file.inString) {
      return MessageType.file;
    } else if (type == MessageType.reply.inString) {
      return MessageType.reply;
    } else if (type == MessageType.allDeleted.inString) {
      return MessageType.allDeleted;
    } else {
      throw ("V_CHAT_SAY =>>>> type in MessageType is ${type.toString()}");
    }
  }
}
