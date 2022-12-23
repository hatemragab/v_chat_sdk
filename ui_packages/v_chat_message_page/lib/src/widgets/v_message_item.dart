import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/direction_item_holder.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'message_items/shared/message_time_widget.dart';

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
    //we have date divider holder
    //we have normal holder
    //we have info holder

    final isMeSender = message.isMeSender;

    return InkWell(
      onLongPress: () {
        if (onMessageItemPress == null) return;
        onMessageItemPress!(message);
      },
      child: DirectionItemHolder(
        isMeSender: isMeSender,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            "${message.getTextTrans} isMeSender = $isMeSender".text,
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MessageTimeWidget(
                  dateTime: message.createdAtDate,
                ),
                Icon(Icons.mic)
              ],
            )
          ],
        ),
      ),
    );
  }
}
