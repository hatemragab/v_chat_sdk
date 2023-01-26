import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';

class VMentionWithPhoto extends MentionData {
  final String photo;

  VMentionWithPhoto({
    required super.id,
    required super.display,
    required this.photo,
  });
}
