import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class DateDividerItem extends StatelessWidget {
  final DateTime dateTime;

  const DateDividerItem({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DateFormat("yyyy-MM-dd")
                  .format(dateTime)
                  .toString()
                  .text
                  .color(Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
