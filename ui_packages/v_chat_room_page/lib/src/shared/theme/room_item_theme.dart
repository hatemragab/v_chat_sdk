import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../widgets/room_item_builder/chat_avatar_image.dart';

class VChatItemBuilder {
  VChatItemBuilder._({
    required this.getChatTitle,
    required this.lastMessageStatus,
    required this.muteIcon,
    required this.unSeenLastMessageTextStyle,
    required this.seenLastMessageTextStyle,
    required this.getChatAvatar,
  });

  final Widget Function(String title) getChatTitle;
  final Widget Function(VFullUrlModel urlModel, String chatTitle, bool isOnline)
      getChatAvatar;
  final VMsgStatusTheme lastMessageStatus;
  final Widget muteIcon;
  final TextStyle seenLastMessageTextStyle;
  final TextStyle unSeenLastMessageTextStyle;

  factory VChatItemBuilder.light() {
    return VChatItemBuilder._(
      getChatTitle: (title) {
        return Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          overflow: TextOverflow.ellipsis,
        );
      },
      getChatAvatar: (urlModel, chatTitle, isOnline) => ChatAvatarImage(
        imageUrl: urlModel,
        isOnline: isOnline,
        chatTitle: chatTitle,
      ),
      muteIcon: const Icon(Icons.notifications_off),
      unSeenLastMessageTextStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      seenLastMessageTextStyle:
          const TextStyle(overflow: TextOverflow.ellipsis, color: Colors.grey),
      lastMessageStatus: const VMsgStatusTheme.light(),
    );
  }

  factory VChatItemBuilder.dark() {
    return VChatItemBuilder._(
      muteIcon: const Icon(Icons.notifications_off),
      getChatTitle: (title) {
        return Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          overflow: TextOverflow.ellipsis,
        );
      },
      getChatAvatar: (urlModel, chatTitle, isOnline) => ChatAvatarImage(
        imageUrl: urlModel,
        isOnline: isOnline,
        chatTitle: chatTitle,
      ),
      unSeenLastMessageTextStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      seenLastMessageTextStyle:
          const TextStyle(overflow: TextOverflow.ellipsis, color: Colors.grey),
      lastMessageStatus: const VMsgStatusTheme.dark(),
    );
  }
}
