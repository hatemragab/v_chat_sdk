import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../room_item_widgets/message_status_icon.dart';
import '../room_item_widgets/room_item_msg.dart';
import '../room_item_widgets/room_last_msg_time.dart';
import '../room_item_widgets/room_mute_widget.dart';
import '../room_item_widgets/room_typing_widget.dart';
import '../room_item_widgets/room_un_read_counter.dart';

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
        radius: 28,
        backgroundImage: NetworkImage(room.thumbImage.fullUrl),
      ),
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero.copyWith(right: 10, left: 10),
      style: ListTileStyle.list,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child:
                room.title.text.maxLine(1).alignStart.overflowEllipsis.styled(
                      style: vRoomTheme.titleStyle,
                    ),
          ),
          RoomLastMsgTime(
            isRoomUnread: room.isRoomUnread,
            lastMessageTimeString: room.lastMessageTimeString,
          )
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (room.roomTypingText != null)
            RoomTypingWidget(
              text: room.roomTypingText!,
            )
          else if (room.lastMessage.isMeSender)
            Flexible(
              child: Row(
                children: [
                  //status
                  MessageStatusIcon(vBaseMessage: room.lastMessage),
                  //grey
                  Flexible(
                    child: RoomItemMsg(
                      msg: room.lastMessage.getTextTrans,
                      isBold: false,
                    ),
                  )
                ],
              ),
            )
          else if (room.isRoomUnread)
            //bold
            Flexible(
              child: RoomItemMsg(
                msg: room.lastMessage.getTextTrans,
                isBold: true,
              ),
            )
          else
            //normal gray
            Flexible(
              child: RoomItemMsg(
                msg: room.lastMessage.getTextTrans,
                isBold: false,
              ),
            ),
          Row(
            children: [
              RoomMuteWidget(isMuted: room.isMuted),
              RoomUnReadWidget(unReadCount: room.unReadCount),
            ],
          )
        ],
      ),
    );
  }
}
