import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class InputState {
  VBaseMessage? replyMsg;
  bool isCloseInput;

  InputState({this.replyMsg, this.isCloseInput = false});

  @override
  String toString() {
    return 'InputState{replyMsg: $replyMsg, isCloseInput: $isCloseInput}';
  }
}
