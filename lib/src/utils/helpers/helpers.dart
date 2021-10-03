
import 'package:path/path.dart';

import '../../enums/message_type.dart';

class Helpers {


  static String baseName(String path) {
    return basename(path);
  }

  static DateTime getLocalTime(int time) {
    return DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toLocal();
  }

  // ignore: type_annotate_public_apis
  static get getCreatedAtUtc => DateTime.now().toUtc().millisecondsSinceEpoch;

  static bool isMessageHasAttachment(MessageType t) {
    return t != MessageType.text &&
        t != MessageType.info &&
        t != MessageType.allDeleted;
  }
}
