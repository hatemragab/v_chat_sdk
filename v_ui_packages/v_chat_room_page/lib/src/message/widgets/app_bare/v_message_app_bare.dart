import 'package:flutter/material.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../models/app_bare_state_model.dart';
import '../message_items/shared/message_typing_widget.dart';

class VMessageAppBare extends StatelessWidget {
  final MessageAppBarStateModel state;
  final Function(BuildContext context, String id, VRoomType roomType)
      onTitlePress;

  const VMessageAppBare({
    Key? key,
    required this.state,
    required this.onTitlePress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      elevation: 1,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: context.vRoomTheme.vChatItemBuilder.getChatAvatar(
          imageUrl: state.roomImage,
          chatTitle: state.roomTitle,
          isOnline: state.isOnline,
          size: 44,
        ),
        minLeadingWidth: 0,
        onTap: () {
          onTitlePress(
            context,
            state.peerIdentifier ?? state.roomId,
            state.roomType,
          );
        },
        title: Text(
          state.roomTitle,
        ),
        subtitle: state.typingText != null
            ? MessageTypingWidget(
                text: state.typingText!,
              )
            : _getSubTitle(),
      ),
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            if (value == 'Search') {
              //focusNode.requestFocus();
              // controller.toggleSearchMode();
              // onSearchClicked();
            } else if (value == 'view') {
              //onViewContactClicked();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            PopupMenuItem(
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
                  Text("Search"),
                ],
              ),
            ),
            PopupMenuItem(
              value: "view",
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: context.isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text("Settings"),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget? _getSubTitle() {
    if (state.roomType.isSingleOrOrder) {
      if (state.isOnline) {
        return const Text("Online");
      }
      if (state.lastSeenAt == null) {
        return null;
      } else {
        return Text(state.lastSeenAt!.toString());
      }
    }
    return null;
  }
}
