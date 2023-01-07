import 'package:flutter/material.dart';

import '../../../shared/theme/theme.dart';
import '../../widgets/room_item_builder/chat_avatar_image.dart';

typedef VChatImageBuilderWidget = Widget Function({
  required String imageUrl,
  required String chatTitle,
  required bool isOnline,
  required int size,
});

class VChatItemBuilder {
  VChatItemBuilder._({
    required this.getChatTitle,
    required this.lastMessageStatus,
    required this.muteIcon,
    required this.unSeenLastMessageTextStyle,
    required this.seenLastMessageTextStyle,
    required this.getChatAvatar,
    required this.selectedRoomColor,
  });

  final Widget Function(String title) getChatTitle;
  final Color selectedRoomColor;
  final VChatImageBuilderWidget getChatAvatar;
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
      getChatAvatar: ({
        required chatTitle,
        required imageUrl,
        required isOnline,
        required size,
      }) {
        return ChatAvatarImage(
          imageUrl: imageUrl,
          isOnline: isOnline,
          size: size,
          chatTitle: chatTitle,
        );
      },
      muteIcon: const Icon(Icons.notifications_off),
      selectedRoomColor: Colors.black.withOpacity(.2),
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
      selectedRoomColor: Colors.white.withOpacity(.2),
      getChatTitle: (title) {
        return Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          overflow: TextOverflow.ellipsis,
        );
      },
      getChatAvatar: ({
        required chatTitle,
        required imageUrl,
        required isOnline,
        required size,
      }) {
        return ChatAvatarImage(
          imageUrl: imageUrl,
          isOnline: isOnline,
          size: size,
          chatTitle: chatTitle,
        );
      },
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
