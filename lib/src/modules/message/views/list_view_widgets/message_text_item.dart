import 'package:flutter/material.dart';
import '../../../../models/v_chat_message.dart';
import '../../../../services/v_chat_app_service.dart';
import '../../../../utils/custom_widgets/auto_direction.dart';
import '../../../../utils/custom_widgets/read_more_text.dart';

class MessageTextItem extends StatelessWidget {
  final VChatMessage message;
  final bool isSender;

  const MessageTextItem({
    Key? key,
    required this.message,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = VChatAppService.to.getTrans(context);
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: isSender
            ? isDark
                ? const Color(0xff876969)
                : Colors.tealAccent
            : isDark
                ? Colors.black26
                : Colors.blueGrey[100],
        borderRadius: getContainerBorder(isSender: isSender),
        border: Border.all(color: Colors.black12),
      ),
      child: AutoDirection(
        text: message.content,
        child: ReadMoreText(
          message.content.toString(),
          trimLines: 5,
          trimMode: TrimMode.line,
          trimCollapsedText: t.showMore(),
          trimExpandedText: t.showLess(),
          moreStyle: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.red),
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }

  BorderRadius getContainerBorder({required bool isSender}) {
    const radius = 17.0;
    if (isSender) {
      return const BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );
    } else {
      return const BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
        topLeft: Radius.circular(radius),
      );
    }
  }
}
