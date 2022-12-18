import 'package:flutter/material.dart';

import '../../v_chat_utils.dart';

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
