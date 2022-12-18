import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MentionWithPhoto extends MentionData {
  final VFullUrlModel photo;

  MentionWithPhoto({
    required super.id,
    required super.display,
    required this.photo,
  });
}
