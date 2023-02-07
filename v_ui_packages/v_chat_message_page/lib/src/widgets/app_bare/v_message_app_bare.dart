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

  const VMessageAppBare({
    Key? key,
    required this.state,
    required this.onTitlePress,
    required this.onSearch,
    required this.onCreateCall,
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
                  Text(VTrans.of(context).labels.search),
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
                  Text(VTrans.of(context).labels.media),
                ],
              ),
            ),
          ],
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
    } else if (state.roomType.isGroup && state.memberCount != null) {
      return Text("${VTrans.of(context).labels.members} ${state.memberCount}");
    }
    return null;
  }

  Widget _getCallIcon() {
    if (state.roomType.isSingleOrOrder) {
      return Row(
        children: [
          InkWell(
            onTap: () => onCreateCall(true),
            child: const Icon(
              PhosphorIcons.videoCameraFill,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () => onCreateCall(false),
            child: const Icon(
              PhosphorIcons.phoneCallFill,
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
