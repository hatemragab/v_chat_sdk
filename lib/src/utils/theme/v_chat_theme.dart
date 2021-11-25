import 'package:flutter/material.dart';

class VChatTheme {
  ///vChat Dialog Theme (loading,ask,info)
  DialogTheme? vChatDialogTheme;

  /// dialogs Button
  ElevatedButtonThemeData? vChatButtonTheme;

  /// package primary color
  Color? primaryColor;

  /// notifications and camera icons
  IconThemeData? iconTheme;

  /// accentColor
  Color? accentColor;

  /// scaffold Background Color
  Color? scaffoldBackgroundColor;

  /// seen Message In Rooms
  TextStyle? seenMessageInRooms;

  /// message appbar
  AppBarTheme? appBarTheme;

  ///represent user name in rooms && un seen in rooms page
  TextStyle? boldTitle;




  ///represent small text information like video and file data in message page
  TextStyle? cationStyle;

  ///typing Or Recording In Rooms
  TextStyle? typingOrRecordingInRooms;

  /// typing Or Recording In MessageAppBar
  TextStyle? typingOrRecordingInMessageAppBar;

  VChatTheme({
    this.vChatDialogTheme,
    this.vChatButtonTheme,
    this.primaryColor,
    this.iconTheme,
    this.scaffoldBackgroundColor,
    this.appBarTheme,
    this.boldTitle,

    this.seenMessageInRooms,

    this.cationStyle,
    this.typingOrRecordingInRooms,
    this.typingOrRecordingInMessageAppBar,
  });
}
