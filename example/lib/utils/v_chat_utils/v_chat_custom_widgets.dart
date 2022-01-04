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

  // @override
  // Widget senderTextMessageWidget(BuildContext context, String text) {
  //   return Container(
  //     child: Text(text),
  //     color: Colors.grey,
  //     padding: EdgeInsets.all(20),
  //   );
  // }
  //
  //
  // @override
  // Widget receiverTextMessageWidget(BuildContext context, String text) {
  // final isDark =  Theme.of(context).brightness == Brightness.dark;
  //   return Container(
  //     child: Text(text),
  //     color:isDark?Colors.red: Colors.grey,
  //     padding: EdgeInsets.all(20),
  //   );
  // }
}
