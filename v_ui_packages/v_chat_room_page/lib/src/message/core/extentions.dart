import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

extension VSortMessagesById on List<VBaseMessage> {
  List<VBaseMessage> sortById() {
    sort((a, b) {
      return b.id.compareTo(a.id);
    });
    return this;
  }
}
