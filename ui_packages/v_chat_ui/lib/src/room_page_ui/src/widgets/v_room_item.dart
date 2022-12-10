import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_ui.dart';
import 'colored_circle_container.dart';

class VRoomItem extends StatelessWidget {
  final VRoom room;
  final Function(VRoom room) onRoomItemPress;

  const VRoomItem({
    required this.room,
    super.key,
    required this.onRoomItemPress,
  });

  @override
  Widget build(BuildContext context) {
    final vTheme = VTheme.of(context)!.vThemeData;
    return ListTile(
      onLongPress: () {
        onRoomItemPress(room);
      },
      onTap: () {
        onRoomItemPress(room);
      },
      leading: CircleAvatar(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        radius: 35,
        backgroundImage: NetworkImage(room.thumbImage.fullUrl),
      ),
      isThreeLine: false,
      contentPadding: EdgeInsets.zero,
      style: ListTileStyle.list,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: room.title.h6.maxLine(1).alignStart.overflowEllipsis,
          ),
          _getMessageTime(vTheme)
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getTypingOrMessage(vTheme),
          Row(
            children: [
              if (room.isMuted)
                vTheme.iconBuilder.muteIcon
              else
                const SizedBox.shrink(),
              _getRoomUnreadCount(),
            ],
          )
        ],
      ),
    );
  }

  Widget _getMessageTime(VThemeData vThemeData) {
    return room.lastMessageTimeString.h6.size(14).regular.color(
          room.isRoomUnread ? Colors.black : Colors.grey,
        );
  }

  Widget _getRoomUnreadCount() {
    if (room.isRoomUnread) {
      return ColoredCircleContainer(
        text: room.unReadCount.toString(),
        padding: const EdgeInsets.all(6),
        backgroundColor: Colors.grey,
      );
    }
    return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(6),
      child: "".text,
    );
  }

  Widget _getTypingOrMessage(VThemeData themeData) {
    final String? roomTyping = room.roomTypingText;
    if (roomTyping != null) {
      return roomTyping.text.color(Colors.green);
    }
    return Flexible(
      child: Row(
        children: [
          _getMessageStatusIfSender(themeData),
          if (room.isRoomUnread)
            Flexible(
              child: room.lastMessage.content.text.medium
                  .color(Colors.black)
                  .maxLine(1)
                  .overflowEllipsis,
            )
          else
            Flexible(
              child: room.lastMessage.content.text.maxLine(1).overflowEllipsis,
            ),
        ],
      ),
    );
  }

  Widget _getMessageStatusIfSender(VThemeData themeData) {
    final isSender = room.lastMessage.isMeSender;
    Widget icon = themeData.iconBuilder.sendMessageIcon;
    if (isSender) {
      if (room.lastMessage.isSending) {
        icon = themeData.iconBuilder.pendingMessageIcon;
      }
      if (room.lastMessage.isSendError) {
        icon = themeData.iconBuilder.errorMessageIcon;
      } else if (room.lastMessage.seenAt != null) {
        icon = themeData.iconBuilder.deliverMessageIcon;
      } else if (room.lastMessage.deliveredAt != null) {
        icon = themeData.iconBuilder.seenMessageIcon;
      }
      return Padding(
        padding: const EdgeInsets.only(right: 3),
        child: icon,
      );
    }
    return const SizedBox.shrink();
  }
}
