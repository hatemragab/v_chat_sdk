import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class RoomLastMsgTime extends StatelessWidget {
  final String lastMessageTimeString;
  final bool isRoomUnread;

  const RoomLastMsgTime({
    Key? key,
    required this.lastMessageTimeString,
    required this.isRoomUnread,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return lastMessageTimeString.cap;
  }
}
