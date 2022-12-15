import 'package:flutter/material.dart';

import '../colored_circle_container.dart';

class RoomUnReadWidget extends StatelessWidget {
  final int unReadCount;

  const RoomUnReadWidget({Key? key, required this.unReadCount})
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
