import 'package:flutter/material.dart' hide Badge;
import 'package:v_chat_utils/v_chat_utils.dart';

class ChatUnReadWidget extends StatelessWidget {
  final int unReadCount;

  const ChatUnReadWidget({Key? key, required this.unReadCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (unReadCount == 0) return const SizedBox.shrink();
    return FittedBox(
      child: Container(
        height: 22,
        padding: EdgeInsets.zero,
        width: 22,
        alignment: Alignment.center,
        decoration:
            const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: unReadCount.toString().text,
      ),
    );
  }
}
