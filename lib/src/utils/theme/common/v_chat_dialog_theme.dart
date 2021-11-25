import 'package:flutter/material.dart';

class VChatDialogTheme {
  TextStyle? titleStyle;
  TextStyle? buttonTextStyle;
  EdgeInsets? buttonContentPadding;
  int? elevation;
  BorderRadius? dialogBorderRadius;
  Color? buttonColor;
  Color? backgroundColor;

  VChatDialogTheme({
    this.titleStyle,
    this.buttonTextStyle,
    this.buttonContentPadding,
    this.elevation,
    this.dialogBorderRadius,
    this.buttonColor,
    this.backgroundColor,
  });

  VChatDialogTheme.dark() {
    titleStyle = const TextStyle(color: Colors.black, fontSize: 23);
    buttonTextStyle = const TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
    buttonContentPadding = const EdgeInsets.all(5);
    elevation = 0;
    dialogBorderRadius = BorderRadius.circular(20);
    backgroundColor = Colors.white;
    buttonColor = Colors.red;
  }

  VChatDialogTheme.light() {
    titleStyle = const TextStyle(color: Colors.white, fontSize: 23);
    buttonTextStyle = const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
    buttonContentPadding = const EdgeInsets.all(5);
    elevation = 0;
    dialogBorderRadius = BorderRadius.circular(20);
    backgroundColor = Colors.black45;
    buttonColor = Colors.red;
  }
}
