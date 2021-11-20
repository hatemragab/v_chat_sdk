import 'package:flutter/material.dart';
import 'package:v_chat_sdk/src/utils/theme/message_page_theme/message_file_item.dart';
import 'message_appbar_theme.dart';
import 'circle_message_theme.dart';
import 'message_record_item.dart';

class MessagePageTheme {
  MessageAppbarTheme? messageAppbarTheme;
  Color? backgroundColor;
  TextStyle? messageTimeStyle;
  CircleMessageTheme? dayCircleTheme;
  CircleMessageTheme Function(bool isSender)? sendMessageTheme;
  CircleMessageTheme Function(bool isSender)? receivedMessageTheme;
  MessageFileItem? messageFileItemStyle;
  MessageRecordItem? messageRecordItemStyle;

  MessagePageTheme({
    this.messageAppbarTheme,
    this.backgroundColor,
    this.messageTimeStyle,
    this.dayCircleTheme,
    this.sendMessageTheme,
    this.receivedMessageTheme,
    this.messageFileItemStyle,
    this.messageRecordItemStyle,
  });
}
