import 'package:flutter/material.dart';
import 'package:v_chat_sdk/src/utils/theme/common/v_chat_icon_theme.dart';

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
