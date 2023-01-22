import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_utils/v_chat_utils.dart';


typedef VChatImageBuilderWidget = Widget Function({
  required String imageUrl,
  required String chatTitle,
  required bool isOnline,
  required int size,
});

class VRoomTheme extends ThemeExtension<VRoomTheme> {
  final BoxDecoration scaffoldDecoration;
  final Widget Function(String title) getChatTitle;
  final Color selectedRoomColor;
  final VChatImageBuilderWidget getChatAvatar;
  final VMsgStatusTheme lastMessageStatus;
  final Widget muteIcon;
  final TextStyle seenLastMessageTextStyle;
  final TextStyle unSeenLastMessageTextStyle;

  VRoomTheme._({
    required this.scaffoldDecoration,
    required this.getChatTitle,
    required this.lastMessageStatus,
    required this.muteIcon,
    required this.unSeenLastMessageTextStyle,
    required this.seenLastMessageTextStyle,
    required this.getChatAvatar,
    required this.selectedRoomColor,
  });

  factory VRoomTheme.light() {
    return VRoomTheme._(
      scaffoldDecoration: const BoxDecoration(
          color: Color(0xffeee4e4)
      ),
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
        return VChatAvatarImage(
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

  factory VRoomTheme.dark() {
    return VRoomTheme._(
      scaffoldDecoration: const BoxDecoration(),
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
        return VChatAvatarImage(
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

  @override
  ThemeExtension<VRoomTheme> lerp(ThemeExtension<VRoomTheme>? other, double t) {
    if (other is! VRoomTheme) {
      return this;
    }
    return this;
  }

  VRoomTheme copyWith({
    BoxDecoration? scaffoldDecoration,
    Widget Function(String title)? getChatTitle,
    Color? selectedRoomColor,
    VChatImageBuilderWidget? getChatAvatar,
    VMsgStatusTheme? lastMessageStatus,
    Widget? muteIcon,
    TextStyle? seenLastMessageTextStyle,
    TextStyle? unSeenLastMessageTextStyle,
  }) {
    return VRoomTheme._(
      scaffoldDecoration: scaffoldDecoration ?? this.scaffoldDecoration,
      getChatTitle: getChatTitle ?? this.getChatTitle,
      selectedRoomColor: selectedRoomColor ?? this.selectedRoomColor,
      getChatAvatar: getChatAvatar ?? this.getChatAvatar,
      lastMessageStatus: lastMessageStatus ?? this.lastMessageStatus,
      muteIcon: muteIcon ?? this.muteIcon,
      seenLastMessageTextStyle:
          seenLastMessageTextStyle ?? this.seenLastMessageTextStyle,
      unSeenLastMessageTextStyle:
          unSeenLastMessageTextStyle ?? this.unSeenLastMessageTextStyle,
    );
  }
}

extension VRoomThemeExt on BuildContext {
  VRoomTheme get vRoomTheme {
    final VRoomTheme? theme = Theme.of(this).extension<VRoomTheme>();
    if (theme == null) {
      if (Theme.of(this).brightness == Brightness.dark) {
        return VRoomTheme.dark();
      } else {
        return VRoomTheme.light();
      }
    }
    return theme;
  }
}
