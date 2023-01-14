import 'package:flutter/cupertino.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class MessageTimeWidget extends StatelessWidget {
  final DateTime dateTime;

  const MessageTimeWidget({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DateFormat.jm().format(dateTime.toLocal()).cap,
    );
  }
}
