import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

/// override the widgets that you want to update it
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
