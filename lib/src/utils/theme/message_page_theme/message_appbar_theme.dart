import 'package:flutter/material.dart';

import '../theme.dart';

class MessageAppbarTheme {
  Color? background;
  TextStyle? userName;
  int? elevation;
  TextStyle? onlineTextStyle;
  TextStyle? typingOrRecordingStyle;
  VChatIconTheme? onlineIconTheme;
  void Function(String email)? onUserAvatarPressed;

  MessageAppbarTheme({
    this.background,
    this.userName,
    this.elevation,
    this.onlineTextStyle,
    this.typingOrRecordingStyle,
    this.onlineIconTheme,
    this.onUserAvatarPressed,
  });
}
