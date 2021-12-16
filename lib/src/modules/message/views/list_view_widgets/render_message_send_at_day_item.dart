import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import '../../../../models/v_chat_message.dart';
import '../../../../utils/custom_widgets/rounded_container.dart';
import '../../../../utils/date_util.dart';

class RenderMessageSendAtDayItem extends StatelessWidget {
  final int index;
  final VChatMessage message;
  final List<VChatMessage> messages;

  const RenderMessageSendAtDayItem({
    Key? key,
    required this.index,
    required this.message,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (index == messages.length - 1) {
      return getLabelDay(context, message.createdAt);
    }

    final lastMessageSendAt =
        DateTime.fromMillisecondsSinceEpoch(messages[index + 1].createdAt);

    final messageSendAt =
        DateTime.fromMillisecondsSinceEpoch(message.createdAt);

    final formatter = UtilDates.formatDay;

    final formattedLastMessageSendAt = formatter.format(lastMessageSendAt);

    final formattedMessageSendAt = formatter.format(messageSendAt);

    if (formattedLastMessageSendAt != formattedMessageSendAt) {
      return getLabelDay(context, message.createdAt);
    }
    return const SizedBox.shrink();
  }

  Widget getLabelDay(BuildContext context, int milliseconds) {
    final day = UtilDates.getSendAtDay(context, milliseconds);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedContainer(
          color: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          borderRadius: BorderRadius.circular(20),
          child: day.text.color(Colors.white),
        ),
      ],
    );
  }
}
