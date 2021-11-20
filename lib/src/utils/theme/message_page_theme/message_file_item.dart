import 'package:flutter/material.dart';

class MessageFileItem {
  EdgeInsets? contentPadding;
  Widget? fileIcon;
  TextStyle? filename;
  TextStyle? fileSize;
  Color? backgroundColor;

  MessageFileItem({
    this.contentPadding,
    this.fileIcon,
    this.filename,
    this.fileSize,
    this.backgroundColor,
  });
}
