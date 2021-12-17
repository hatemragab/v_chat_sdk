import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

class VChatCustomWidgets extends VChatWidgetBuilder {
  @override
  Color sendButtonColor(BuildContext context, {required bool isDark}) {
    if (isDark) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}
