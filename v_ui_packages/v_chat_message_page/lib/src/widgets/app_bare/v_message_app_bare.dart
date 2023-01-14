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

  const VMessageAppBare({
    Key? key,
    required this.state,
    required this.onTitlePress,
    required this.onSearch,
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
        // leading: context.vRoomTheme.vChatItemBuilder.getChatAvatar(
        //   imageUrl: state.roomImage,
        //   chatTitle: state.roomTitle,
        //   isOnline: state.isOnline,
        //   size: 44,
        // ),
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
        _getCallIcon(),
        PopupMenuButton(
          onSelected: (value) {
            if (value == 'Search') {
              onSearch();
              //focusNode.requestFocus();
              // controller.toggleSearchMode();
              // onSearchClicked();
            } else if (value == 'media') {
              onViewMedia();
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
                  const Text("Search"),
                ],
              ),
            ),
            PopupMenuItem(
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
                  const Text("Media"),
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
        //todo trans
        return const Text("Online");
      }
      if (state.lastSeenAt == null) {
        return null;
      } else {
        //todo trans
        return Text(
          format(state.lastSeenAt!.toLocal()),
        );
      }
    }
    return null;
  }

  Widget _getCallIcon() {
    if (state.roomType.isSingleOrOrder) {
      return const Icon(Icons.call);
    }
    return const SizedBox();
  }
}
