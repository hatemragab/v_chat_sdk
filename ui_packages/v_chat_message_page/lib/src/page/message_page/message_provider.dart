import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../assets/data/api_messages.dart';
import '../../assets/data/local_messages.dart';

class MessageProvider {
  Future<List<VBaseMessage>> getFakeMessages() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return fakeLocalMessages
        .map((e) => MessageFactory.createBaseMessage(e))
        .toList();
  }

  Future<List<VBaseMessage>> getFakeApiMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return fakeApiMessages
        .map((e) => MessageFactory.createBaseMessage(e))
        .toList();
  }
}
