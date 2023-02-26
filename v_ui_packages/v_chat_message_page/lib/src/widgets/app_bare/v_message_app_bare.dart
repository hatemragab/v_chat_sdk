// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../models/app_bare_state_model.dart';
import '../message_items/shared/message_typing_widget.dart';

class VMessageAppBare extends StatelessWidget {
  final MessageAppBarStateModel state;
  final Function(
    BuildContext context,
    String id,
    VRoomType roomType,
  ) onTitlePress;
  final VoidCallback onSearch;
  final VoidCallback onViewMedia;
  final Function(bool isVideo) onCreateCall;
  final Function(bool isBlocked) onUpdateBlock;
  final bool isCallsAllow;

  const VMessageAppBare({
    Key? key,
    required this.state,
    required this.onTitlePress,
    required this.onSearch,
    required this.onCreateCall,
    required this.onViewMedia,
    required this.onUpdateBlock,
    required this.isCallsAllow,
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
          imageUrl: state.roomImage,
          chatTitle: state.roomTitle,
          isOnline: state.isOnline,
          size: 40,
        ),
        horizontalTitleGap: 12,
        minLeadingWidth: 0,
        onTap: () {
          onTitlePress(
            context,
            state.peerIdentifier ?? state.roomId,
            state.roomType,
          );
        },
        title: state.roomTitle.text.bold,
        subtitle: state.typingText(context) != null
            ? MessageTypingWidget(
                text: state.typingText(context)!,
              )
            : _getSubTitle(context),
      ),
      actions: [
        _getCallIcon(),
        PopupMenuButton(
          onSelected: (value) {
            //don't not translate
            if (value == 'Search') {
              onSearch();
              //focusNode.requestFocus();
              // controller.toggleSearchMode();
              // onSearchClicked();
              //don't not translate
            } else if (value == 'media') {
              onViewMedia();
              //don't not translate
            } else if (value == 'block') {
              onUpdateBlock(true);
              //don't not translate
            } else if (value == 'un_block') {
              onUpdateBlock(false);
            }
          },
          itemBuilder: (BuildContext context) {
            final l = <PopupMenuItem<String>>[
              PopupMenuItem(
                //don't not translate
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
                //don't not translate
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
            if (state.roomType.isSingleOrOrder) {
              final map = VAppPref.getMap("ban-${state.roomId}");
              final banModel = map == null ? null : VCheckBanModel.fromMap(map);
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
                  //don't not translate
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
    if (state.roomType.isSingleOrOrder) {
      if (state.isOnline) {
        return Text(VTrans.of(context).labels.online);
      }
      if (state.lastSeenAt == null) {
        return null;
      } else {
        return Text(
          format(
            state.lastSeenAt!.toLocal(),
            locale: VAppConstants.sdkLanguage,
          ),
        );
      }
    } else if (state.memberCount != null) {
      return Text("${VTrans.of(context).labels.members} ${state.memberCount}");
    }
    return null;
  }

  Widget _getCallIcon() {
    if (state.roomType.isSingleOrOrder) {
      return Row(
        children: [
          InkWell(
            onTap: () {
              if (!isCallsAllow) return;
              onCreateCall(true);
            },
            child: Icon(
              PhosphorIcons.videoCameraFill,
              color: isCallsAllow ? null : Colors.grey,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              if (!isCallsAllow) return;
              onCreateCall(false);
            },
            child: Icon(
              PhosphorIcons.phoneCallFill,
              color: isCallsAllow ? null : Colors.grey,
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
