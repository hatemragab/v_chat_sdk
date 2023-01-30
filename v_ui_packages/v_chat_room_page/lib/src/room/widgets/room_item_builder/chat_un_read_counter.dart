import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import '../../shared/colored_circle_container.dart';

class ChatUnReadWidget extends StatelessWidget {
  final int unReadCount;

  const ChatUnReadWidget({Key? key, required this.unReadCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (unReadCount == 0) return const SizedBox.shrink();
    return Badge(
      showBadge: unReadCount != 0,
      badgeContent: SizedBox(
        height: 12,
        width: 12,
        child: FittedBox(
          child: Text(
            "$unReadCount",
          ),
        ),
      ),
      badgeStyle: const BadgeStyle(
        elevation: 0,
        badgeColor: Colors.green,
      ),
    );
    // return Badg(
    //   text: unReadCount.toString(),
    //   padding: const EdgeInsets.all(6),
    //   backgroundColor: Colors.grey,
    // );
  }
}
