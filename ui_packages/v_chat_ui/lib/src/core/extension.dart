import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_ui/src/core/v_theme/theme_extension/v_room_theme.dart';

extension MediaQueryExt2 on BuildContext {
  bool get isDark => platformBrightness == Brightness.dark;

  Future<T?> toPage<T>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  VRoomTheme get vRoomTheme {
    final VRoomTheme? theme = Theme.of(this).extension<VRoomTheme>();
    if (theme == null) {
      if (isDark) {
        return VRoomTheme.dark();
      } else {
        return VRoomTheme.light();
      }
    }
    return theme;
  }
}
