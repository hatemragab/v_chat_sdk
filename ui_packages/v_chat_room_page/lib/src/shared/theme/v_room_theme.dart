import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/shared/theme/room_item_theme.dart';

class VRoomTheme extends ThemeExtension<VRoomTheme> {
  final VChatItemBuilder vChatItemBuilder;

  VRoomTheme._({
    required this.vChatItemBuilder,
  });

  factory VRoomTheme.light() {
    return VRoomTheme._(
      vChatItemBuilder: VChatItemBuilder.light(),
    );
  }

  factory VRoomTheme.dark() {
    return VRoomTheme._(
      vChatItemBuilder: VChatItemBuilder.dark(),
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
    VChatItemBuilder? vChatItemBuilder,
  }) {
    return VRoomTheme._(
      vChatItemBuilder: vChatItemBuilder ?? this.vChatItemBuilder,
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
