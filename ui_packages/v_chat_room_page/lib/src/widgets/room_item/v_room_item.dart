import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/chat.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../room_item_builder/chat_last_msg_time.dart';
import '../room_item_builder/chat_mute_widget.dart';
import '../room_item_builder/chat_title.dart';
import '../room_item_builder/chat_typing_widget.dart';
import '../room_item_builder/chat_un_read_counter.dart';
import '../room_item_builder/message_status_icon.dart';
import '../room_item_builder/room_item_msg.dart';

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
    final theme = context.vRoomTheme;
    return InkWell(
      onTap: () {
        onRoomItemPress(room);
      },
      onLongPress: () {
        onRoomItemLongPress(room);
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 65,
          width: 65,
          child: Row(
            children: [
              theme.vChatItemBuilder.getChatAvatar(
                room.thumbImage,
                room.title,
                room.isOnline,
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ChatTitle(title: room.title),
                        ),
                        ChatLastMsgTime(
                          lastMessageTimeString: room.lastMessageTimeString,
                        )
                      ],
                    ),
                    const SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (room.roomTypingText != null)
                          ChatTypingWidget(
                            text: room.roomTypingText!,
                          )
                        else if (room.lastMessage.isMeSender)
                          Flexible(
                            child: Row(
                              children: [
                                //status
                                MessageStatusIcon(
                                    vBaseMessage: room.lastMessage),
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
                            ChatMuteWidget(isMuted: room.isMuted),
                            ChatUnReadWidget(unReadCount: room.unReadCount),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    return ListTile(
      horizontalTitleGap: 12,
      dense: false,
      onLongPress: () {
        onRoomItemLongPress(room);
      },
      onTap: () {
        onRoomItemPress(room);
      },

      ///chat avatar
      leading: theme.vChatItemBuilder.getChatAvatar(
        room.thumbImage,
        room.title,
        room.isOnline,
      ),
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero.copyWith(right: 10, left: 10),
      style: ListTileStyle.list,

      ///chat header
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ChatTitle(title: room.title),
          ),
          ChatLastMsgTime(
            lastMessageTimeString: room.lastMessageTimeString,
          )
        ],
      ),

      ///last message with message status if me sender and mute if chat has been muted
      ///and unread counter
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (room.roomTypingText != null)
            ChatTypingWidget(
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
              ChatMuteWidget(isMuted: room.isMuted),
              ChatUnReadWidget(unReadCount: room.unReadCount),
            ],
          )
        ],
      ),
    );
  }
}
