import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class ReplyMsgWidget extends StatelessWidget {
  final VBaseMessage vBaseMessage;
  const ReplyMsgWidget({Key? key, required this.vBaseMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(vBaseMessage.content),
    );
  }
}
