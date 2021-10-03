import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import '../../../models/vchat_message.dart';
import '../../../utils/custom_widgets/rounded_container.dart';
import '../../../utils/date_util.dart';



class RenderMessageSendAtDayItem extends StatelessWidget {
  final int index;
  final VchatMessage message;
  final List<VchatMessage> messages;

  const RenderMessageSendAtDayItem(
      {required this.index, required this.message, required this.messages});

  @override
  Widget build(BuildContext context) {
    if (index == messages.length - 1) {
      return getLabelDay(message.createdAt);
    }

    final lastMessageSendAt =
        DateTime.fromMillisecondsSinceEpoch(messages[index + 1].createdAt);

    final messageSendAt =
        DateTime.fromMillisecondsSinceEpoch(message.createdAt);

    final formatter = UtilDates.formatDay;

    final String formattedLastMessageSendAt =
        formatter.format(lastMessageSendAt);

    final String formattedMessageSendAt = formatter.format(messageSendAt);

    if (formattedLastMessageSendAt != formattedMessageSendAt) {
      return getLabelDay(message.createdAt);
    }
    return Container();
  }

  Widget getLabelDay(int milliseconds) {
    final String day = UtilDates.getSendAtDay(milliseconds);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedContainer(
          child: day.text.color(Colors.white),
          color: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
          borderRadius: BorderRadius.circular(20),
        ),
      ],
    );
  }
}
