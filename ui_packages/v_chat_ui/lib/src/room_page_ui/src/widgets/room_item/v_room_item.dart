import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/src/core/extension.dart';

import '../../../../../v_chat_ui.dart';
import '../colored_circle_container.dart';

class VRoomItem extends StatelessWidget {
  final VRoom room;
  final Function(VRoom room) onRoomItemPress;
  final Function(VRoom room) onRoomItemLongPress;

  const VRoomItem({
    required this.room,
    super.key,
    required this.onRoomItemPress,
    required this.onRoomItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final vRoomTheme = context.vRoomTheme;
    return ListTile(
      dense: false,
      onLongPress: () {
        onRoomItemLongPress(room);
      },
      onTap: () {
        onRoomItemPress(room);
      },
      leading: CircleAvatar(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        radius: 40,
        backgroundImage: NetworkImage(room.thumbImage.fullUrl),
      ),
      isThreeLine: false,
      contentPadding: EdgeInsets.zero,
      style: ListTileStyle.list,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: room.title.h6.maxLine(1).alignStart.overflowEllipsis.styled(
                  style: vRoomTheme.titleStyle,
                ),
          ),
          _getMessageTime(vRoomTheme)
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getTypingOrMessage(vRoomTheme),
          Row(
            children: [
              if (room.isMuted)
                vRoomTheme.muteIcon
              else
                const SizedBox.shrink(),
              _getRoomUnreadCount(),
            ],
          )
        ],
      ),
    );
  }

  Widget _getMessageTime(VRoomTheme vThemeData) {
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
  }

  Widget _getTypingOrMessage(VRoomTheme themeData) {
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

  Widget _getMessageStatusIfSender(VRoomTheme themeData) {
    final isSender = room.lastMessage.isMeSender;
    Widget icon = themeData.vMsgStatusTheme.sendIcon;
    if (isSender) {
      if (room.lastMessage.isSending) {
        themeData.vMsgStatusTheme.pendingIcon;
      }
      if (room.lastMessage.isSendError) {
        icon = themeData.vMsgStatusTheme.refreshIcon;
      } else if (room.lastMessage.seenAt != null) {
        icon = themeData.vMsgStatusTheme.seenIcon;
      } else if (room.lastMessage.deliveredAt != null) {
        icon = themeData.vMsgStatusTheme.deliverIcon;
      }
      return Padding(
        padding: const EdgeInsets.only(right: 3),
        child: icon,
      );
    }
    return const SizedBox.shrink();
  }
}
