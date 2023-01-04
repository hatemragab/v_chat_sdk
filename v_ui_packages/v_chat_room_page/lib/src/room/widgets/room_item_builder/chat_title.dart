import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';

import '../../../../v_chat_room_page.dart';

class ChatTitle extends StatelessWidget {
  final String title;

  const ChatTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.vRoomTheme.vChatItemBuilder.getChatTitle(title);
  }
}
