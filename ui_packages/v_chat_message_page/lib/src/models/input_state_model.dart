import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageInputModel {
  VBaseMessage? replyMsg;
  bool isCloseInput;

  MessageInputModel({
    this.replyMsg,
    required this.isCloseInput,
  });

  @override
  String toString() {
    return 'InputState{replyMsg: $replyMsg, isCloseInput: $isCloseInput}';
  }
}
