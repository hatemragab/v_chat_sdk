// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:textless/textless.dart';
import 'package:timeago/timeago.dart';
import 'package:v_chat_message_page/src/core/extension.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../v_chat/v_chat_avatar_image.dart';
import '../message_items/shared/message_typing_widget.dart';

class VMessageAppBare extends StatelessWidget {
  final Function(BuildContext context) onTitlePress;
  final VoidCallback onSearch;
  final VoidCallback onViewMedia;
  final Function(bool isVideo)? onCreateCall;
  final Function(bool isBlocked)? onUpdateBlock;
  final VRoom room;
  final int? memberCount;
  final int? totalOnline;
  final DateTime? lastSeenAt;
  final String? Function(BuildContext context) inTypingText;
  final bool isCallAllowed;

  const VMessageAppBare({
    Key? key,
    required this.onTitlePress,
    required this.room,
    required this.onSearch,
    required this.inTypingText,
    this.onCreateCall,
    this.memberCount,
    required this.isCallAllowed,
    this.totalOnline,
    this.lastSeenAt,
    this.onUpdateBlock,
    required this.onViewMedia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      elevation: 1,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: VChatAvatarImage(
          imageUrl: room.thumbImage,
          chatTitle: room.title,
          isOnline: room.isOnline,
          size: 40,
        ),
        horizontalTitleGap: 12,
        minLeadingWidth: 0,
        onTap: () {
          onTitlePress(context);
        },
        title: room.title.text.bold.maxLine(2),
        subtitle: inTypingText(context) != null
            ? MessageTypingWidget(
                text: inTypingText(context)!,
              )
            : _getSubTitle(context),
      ),
      actions: [
        _getCallIcon,
        PopupMenuButton(
          onSelected: (value) {
            ///don't not translate
            if (value == 'Search') {
              onSearch();

              ///don't not translate
            } else if (value == 'media') {
              onViewMedia();

              ///don't not translate
            } else if (value == 'block') {
              onUpdateBlock?.call(true);

              ///don't not translate
            } else if (value == 'un_block') {
              onUpdateBlock?.call(false);
            }
          },
          itemBuilder: (BuildContext context) {
            final l = <PopupMenuItem<String>>[
              PopupMenuItem(
                ///don't not translate
                value: "Search",
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: context.isDark ? Colors.white : Colors.black,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(VTrans.of(context).labels.search),
                  ],
                ),
              ),
              PopupMenuItem(
                /// don't not translate
                value: "media",
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                      color: context.isDark ? Colors.white : Colors.black,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(VTrans.of(context).labels.media),
                  ],
                ),
              ),
            ];
            if (room.roomType.isSingleOrOrder) {
              final map = VAppPref.getMap("ban-${room.id}");
              final banModel =
                  map == null ? null : VSingleBlockModel.fromMap(map);
              if (banModel == null || !banModel.isMeBanner) {
                l.add(PopupMenuItem(
                  value: "block",
                  child: Row(
                    children: [
                      const Icon(
                        Icons.block,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(VTrans.of(context).labels.block),
                    ],
                  ),
                ));
              } else {
                l.add(PopupMenuItem(
                  ///don't not translate
                  value: "un_block",
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: context.isDark ? Colors.white : Colors.black,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(VTrans.of(context).labels.unBlock),
                    ],
                  ),
                ));
              }
            }
            return l;
          },
        )
      ],
    );
  }

  Widget? _getSubTitle(BuildContext context) {
    if (room.roomType.isSingleOrOrder) {
      if (room.isOnline) {
        return Text(VTrans.of(context).labels.online);
      }
      if (lastSeenAt == null) {
        return null;
      } else {
        return Text(
          format(
            lastSeenAt!.toLocal(),
            locale: VAppConstants.sdkLanguage,
          ),
        );
      }
    } else if (memberCount != null) {
      if (totalOnline != null) {
        return Text("${VTrans.of(context).labels.members} $memberCount");
      }
      return Text("${VTrans.of(context).labels.members} $memberCount");
    }
    return null;
  }

  Widget get _getCallIcon {
    if (isCallAllowed) {
      return Row(
        children: [
          InkWell(
            onTap: () {
              if (!isCallAllowed) return;
              onCreateCall?.call(true);
            },
            child: Icon(
              PhosphorIcons.videoCameraFill,
              color: isCallAllowed ? null : Colors.grey,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              if (!isCallAllowed) return;
              onCreateCall?.call(false);
            },
            child: Icon(
              PhosphorIcons.phoneCallFill,
              color: isCallAllowed ? null : Colors.grey,
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
