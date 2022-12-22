import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VMessageItem extends StatelessWidget {
  final VBaseMessage message;
  final Function(VBaseMessage msg)? onMessageItemPress;

  const VMessageItem({
    Key? key,
    required this.message,
    this.onMessageItemPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onMessageItemPress != null) {
          onMessageItemPress!(message);
        }
      },
      title: Text(message.getTextTrans),
    );
  }
}
