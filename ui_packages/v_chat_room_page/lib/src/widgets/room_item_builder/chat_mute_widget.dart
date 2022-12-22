import 'package:flutter/cupertino.dart';
import 'package:v_chat_room_page/src/chat.dart';

class ChatMuteWidget extends StatelessWidget {
  final bool isMuted;
  const ChatMuteWidget({Key? key, required this.isMuted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vRoomTheme = context.vRoomTheme;

    if (!isMuted) return const SizedBox.shrink();
    return vRoomTheme.vChatItemBuilder.muteIcon;
  }
}
