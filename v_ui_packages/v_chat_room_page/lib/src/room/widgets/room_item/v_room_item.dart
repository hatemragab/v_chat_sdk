// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../room_item_builder/chat_last_msg_time.dart';
import '../room_item_builder/chat_mute_widget.dart';
import '../room_item_builder/chat_title.dart';
import '../room_item_builder/chat_typing_widget.dart';
import '../room_item_builder/chat_un_read_counter.dart';
import '../room_item_builder/room_item_msg.dart';

class VRoomItem extends StatelessWidget {
  final VRoom room;
  final bool isIconOnly;
  final Function(VRoom room) onRoomItemPress;

  final Function(VRoom room) onRoomItemLongPress;

  const VRoomItem({
    required this.room,
    super.key,
    required this.onRoomItemPress,
    this.isIconOnly = false,
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
      child: Container(
        height: 65,
        width: 65,
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(
          color: room.isSelected ? theme.selectedRoomColor : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isIconOnly
            ? theme.getChatAvatar(
                imageUrl: room.thumbImage,
                chatTitle: room.title,
                isOnline: room.isOnline,
                size: 60,
              )
            : Row(
                children: [
                  theme.getChatAvatar(
                    imageUrl: room.thumbImage,
                    chatTitle: room.title,
                    isOnline: room.isOnline,
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
                            if (room.roomTypingText(context) != null)
                              ChatTypingWidget(
                                text: room.roomTypingText(context)!,
                              )
                            else if (room.lastMessage.isMeSender)
                              Flexible(
                                child: Row(
                                  children: [
                                    //status
                                    MessageStatusIcon(
                                      model: MessageStatusIconDataModel(
                                        isSeen: room.lastMessage.seenAt != null,
                                        isDeliver:
                                            room.lastMessage.deliveredAt !=
                                                null,
                                        emitStatus: room.lastMessage.emitStatus,
                                        isMeSender: room.lastMessage.isMeSender,
                                      ),
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
    );
  }
}
