// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../room_item_builder/chat_last_msg_time.dart';
import '../room_item_builder/chat_mute_widget.dart';
import '../room_item_builder/chat_title.dart';
import '../room_item_builder/chat_typing_widget.dart';
import '../room_item_builder/chat_un_read_counter.dart';
import '../room_item_builder/room_item_msg.dart';
import 'message_status_icon.dart';

/// A widget representing an individual virtual room item.
/// /// This widget handles rendering the room information and can be configured
/// to either show only an icon representation of the room or include additional
/// information. /// /// Required fields:
/// * [room] – The virtual room object that this item represents.
/// * [onRoomItemPress] – Callback function that is triggered when this item is pressed.
/// * [onRoomItemLongPress] – Callback function that is triggered when this item is long pressed.
/// /// Optional fields:
/// * [isIconOnly] – Flag indicating whether to show only the icon representation of the room.
/// ///
/// Example usage:
/// /// dart /// VRoomItem( /// room: myVirtualRoom, /// isIconOnly: true, /// onRoomItemPress: (room) { /// // Handle press event /// }, /// onRoomItemLongPress: (room) { /// // Handle long press event /// }, /// ) ///
class VRoomItem extends StatelessWidget {
  /// The virtual room object that this item represents.
  final VRoom room;

  /// Flag indicating whether to show only the icon representation of the room.
  final bool isIconOnly;

  /// Callback function that is triggered when this item is pressed.
  final VRoomLanguage language;

  /// Callback function that is triggered when this item is long pressed.
  final Function(VRoom room) onRoomItemPress;

  /// Callback function that is triggered when this item is long pressed.
  final Function(VRoom room) onRoomItemLongPress;

  /// Creates a new instance of [VRoomItem].
  const VRoomItem({
    required this.room,
    required this.language,
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
                              yesterdayLabel: language.yesterdayLabel,
                              lastMessageTime: room.lastMessageTime,
                            )
                          ],
                        ),
                        const SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_roomTypingText(room.typingStatus) != null)
                              ChatTypingWidget(
                                text: _roomTypingText(room.typingStatus)!,
                              )
                            else if (room.lastMessage.isMeSender)
                              Flexible(
                                child: Row(
                                  children: [
                                    //status
                                    MessageStatusIcon(
                                      model: MessageStatusIconDataModel(
                                        isAllDeleted:
                                            room.lastMessage.allDeletedAt !=
                                                null,
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
                                        messageHasBeenDeletedLabel:
                                            language.messageHasBeenDeleted,
                                        message: room.lastMessage,
                                        language: language.vMessageInfoTrans,
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
                                  messageHasBeenDeletedLabel:
                                      language.messageHasBeenDeleted,
                                  language: language.vMessageInfoTrans,
                                ),
                              )
                            else
                              //normal gray
                              Flexible(
                                child: RoomItemMsg(
                                  isBold: false,
                                  messageHasBeenDeletedLabel:
                                      language.messageHasBeenDeleted,
                                  message: room.lastMessage,
                                  language: language.vMessageInfoTrans,
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

  String? _roomTypingText(VSocketRoomTypingModel value) {
    if (room.roomType.isSingle) {
      return _inSingleText(value);
    }
    if (room.roomType.isGroup) {
      return _inGroupText(value);
    }
    return null;
  }

  /// Returns a string representation of the typing status.
  String? _inSingleText(VSocketRoomTypingModel value) {
    return _statusInText(value);
  }

  /// Converts the typing status to a localized text.
  String? _statusInText(VSocketRoomTypingModel value) {
    switch (room.typingStatus.status) {
      case VRoomTypingEnum.stop:
        return null;
      case VRoomTypingEnum.typing:
        return language.typing;
      case VRoomTypingEnum.recording:
        return language.recording;
    }
  }

  /// Returns a string representation of the typing status in a group.
  String? _inGroupText(VSocketRoomTypingModel value) {
    if (_statusInText(value) == null) return null;
    return "${value.userName} ${_statusInText(value)!}";
  }
}
