import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../message/widgets/message_items/shared/message_status_icon.dart';
import '../room_item_builder/chat_last_msg_time.dart';
import '../room_item_builder/chat_mute_widget.dart';
import '../room_item_builder/chat_title.dart';
import '../room_item_builder/chat_typing_widget.dart';
import '../room_item_builder/chat_un_read_counter.dart';
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
    if (room.isDeleted) return const SizedBox.shrink();
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
                imageUrl: room.thumbImage,
                chatTitle: room.title,
                isOnline: room.isThereBlock ? false : room.isOnline,
                size: 60,
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
                                  isDeliver:
                                      room.lastMessage.deliveredAt != null,
                                  isSeen: room.lastMessage.seenAt != null,
                                  isMeSender: room.lastMessage.isMeSender,
                                  vBaseMessage: room.lastMessage,
                                ),
                                //grey
                                Flexible(
                                  child: RoomItemMsg(
                                    message: room.lastMessage,
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
                              isBold: true,
                              message: room.lastMessage,
                            ),
                          )
                        else
                          //normal gray
                          Flexible(
                            child: RoomItemMsg(
                              isBold: false,
                              message: room.lastMessage,
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
  }
}
