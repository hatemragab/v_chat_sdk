import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';

class MentionWithPhoto extends MentionData {
  final String photo;

  MentionWithPhoto({
    required super.id,
    required super.display,
    required this.photo,
  });
}
