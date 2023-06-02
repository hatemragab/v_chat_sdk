// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/core/extension.dart';

import '../../v_chat_message_page.dart';

typedef CustomMessageItemTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  Map<String, dynamic> data,
);
typedef ItemHolderColorTypeDef = Color Function(
  BuildContext context,
  bool isMeSender,
  bool isDarkMode,
);

const _darkMeSenderColor = Colors.indigo;
const _darkReceiverColor = Color(0xff515156);

const _lightReceiverColor = Color(0xffffffff);
const _lightMySenderColor = Colors.blue;

const _lightTextMeSenderColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
const _lightTextMeReceiverColor = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

const _darkTextMeSenderColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
const _darkTextReceiverColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

class VMessageTheme extends ThemeExtension<VMessageTheme> {
  final Color senderBubbleColor;
  final Color receiverBubbleColor;
  final VMsgStatusTheme messageSendingStatus;
  final BoxDecoration scaffoldDecoration;
  final CustomMessageItemTypeDef? customMessageItem;
  final TextStyle receiverTextStyle;
  final TextStyle senderTextStyle;
  final BoxDecoration? messageItemHolderDecoration;

  VMessageTheme._({
    required this.senderBubbleColor,
    required this.receiverBubbleColor,
    required this.senderTextStyle,
    this.customMessageItem,
    required this.scaffoldDecoration,
    required this.messageSendingStatus,
    required this.receiverTextStyle,
    this.messageItemHolderDecoration,
  });

  factory VMessageTheme.light() {
    return VMessageTheme._(
      senderBubbleColor: _lightMySenderColor,
      receiverBubbleColor: _lightReceiverColor,
      senderTextStyle: _lightTextMeSenderColor,
      receiverTextStyle: _lightTextMeReceiverColor,
      messageSendingStatus: const VMsgStatusTheme.light(),
      scaffoldDecoration: const BoxDecoration(color: Color(0xffeee4e4)),
    );
  }

  factory VMessageTheme.dark() {
    return VMessageTheme._(
      senderBubbleColor: _darkMeSenderColor,
      receiverBubbleColor: _darkReceiverColor,
      senderTextStyle: _darkTextMeSenderColor,
      receiverTextStyle: _darkTextReceiverColor,
      messageSendingStatus: const VMsgStatusTheme.dark(),
      scaffoldDecoration: const BoxDecoration(),
    );
  }

  @override
  ThemeExtension<VMessageTheme> lerp(
      ThemeExtension<VMessageTheme>? other, double t) {
    if (other is! VMessageTheme) {
      return this;
    }
    return this;
  }

  @override
  VMessageTheme copyWith({
    Color? senderBubbleColor,
    Color? receiverBubbleColor,
    VMsgStatusTheme? messageSendingStatus,
    BoxDecoration? scaffoldDecoration,
    CustomMessageItemTypeDef? customMessageItem,
    TextStyle? receiverTextStyle,
    TextStyle? senderTextStyle,
    BoxDecoration? messageItemHolderDecoration,
  }) {
    return VMessageTheme._(
      senderBubbleColor: senderBubbleColor ?? this.senderBubbleColor,
      receiverBubbleColor: receiverBubbleColor ?? this.receiverBubbleColor,
      messageSendingStatus: messageSendingStatus ?? this.messageSendingStatus,
      scaffoldDecoration: scaffoldDecoration ?? this.scaffoldDecoration,
      customMessageItem: customMessageItem ?? this.customMessageItem,
      receiverTextStyle: receiverTextStyle ?? this.receiverTextStyle,
      senderTextStyle: senderTextStyle ?? this.senderTextStyle,
      messageItemHolderDecoration:
          messageItemHolderDecoration ?? this.messageItemHolderDecoration,
    );
  }
}

extension VMessageThemeNewExt on BuildContext {
  VMessageTheme get vMessageTheme {
    final VMessageTheme? theme = Theme.of(this).extension<VMessageTheme>();
    if (theme == null) {
      if (isDark) {
        return VMessageTheme.dark();
      } else {
        return VMessageTheme.light();
      }
    }
    return theme;
  }

  Color getMessageItemHolderColor(bool isSender, BuildContext context) {
    if (isSender) {
      return context.vMessageTheme.senderBubbleColor;
    } else {
      return context.vMessageTheme.receiverBubbleColor;
    }
  }
}
