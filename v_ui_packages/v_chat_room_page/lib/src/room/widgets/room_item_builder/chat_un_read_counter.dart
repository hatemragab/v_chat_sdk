import 'package:flutter/material.dart';

import '../../shared/colored_circle_container.dart';

class ChatUnReadWidget extends StatelessWidget {
  final int unReadCount;

  const ChatUnReadWidget({Key? key, required this.unReadCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (unReadCount == 0) return const SizedBox.shrink();
    return ColoredCircleContainer(
      text: unReadCount.toString(),
      padding: const EdgeInsets.all(6),
      backgroundColor: Colors.grey,
    );
  }
}
