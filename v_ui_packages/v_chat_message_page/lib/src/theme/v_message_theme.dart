// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/theme/theme_types.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../v_chat_message_page.dart';

class VMessageTheme extends ThemeExtension<VMessageTheme> {
  final BoxDecoration scaffoldDecoration;
  final ItemHolderTypeDef messageItemHolder;
  final CustomMessageItemTypeDef customMessageItem;
  final ItemHolderColorTypeDef messageItemHolderColor;
  final VMsgStatusTheme messageSendingStatus;
  final TextTypeDef textItemStyle;
  final DateDividerTypeDef dateDividerWidget;

  VMessageTheme._({
    required this.scaffoldDecoration,
    required this.messageSendingStatus,
    required this.customMessageItem,
    required this.messageItemHolder,
    required this.textItemStyle,
    required this.dateDividerWidget,
    required this.messageItemHolderColor,
  });

  factory VMessageTheme.light() {
    return VMessageTheme._(
      scaffoldDecoration: const BoxDecoration(color: Color(0xffeee4e4)),
      messageSendingStatus: const VMsgStatusTheme.light(),
      textItemStyle: getTextWidget,
      customMessageItem: (context, isMeSender, data) => const SizedBox(),
      dateDividerWidget: getDateDividerWidget,
      messageItemHolderColor: getMessageItemHolderColor,
      messageItemHolder: getMessageItemHolder,
    );
  }

  factory VMessageTheme.dark() {
    return VMessageTheme._(
      scaffoldDecoration: const BoxDecoration(),
      messageSendingStatus: const VMsgStatusTheme.dark(),
      textItemStyle: getTextWidget,
      customMessageItem: (context, isMeSender, data) => const SizedBox(),
      dateDividerWidget: getDateDividerWidget,
      messageItemHolderColor: getMessageItemHolderColor,
      messageItemHolder: getMessageItemHolder,
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
    BoxDecoration? scaffoldDecoration,
    ItemHolderTypeDef? messageItemHolder,
    ItemHolderColorTypeDef? messageItemHolderColor,
    VMsgStatusTheme? messageSendingStatus,
    TextTypeDef? textItemStyle,
    CustomMessageItemTypeDef? customMessageItem,
    DateDividerTypeDef? dateDividerWidget,
  }) {
    return VMessageTheme._(
      scaffoldDecoration: scaffoldDecoration ?? this.scaffoldDecoration,
      messageItemHolder: messageItemHolder ?? this.messageItemHolder,
      customMessageItem: customMessageItem ?? this.customMessageItem,
      messageItemHolderColor:
          messageItemHolderColor ?? this.messageItemHolderColor,
      messageSendingStatus: messageSendingStatus ?? this.messageSendingStatus,
      textItemStyle: textItemStyle ?? this.textItemStyle,
      dateDividerWidget: dateDividerWidget ?? this.dateDividerWidget,
    );
  }
}

extension VMessageThemeExt on BuildContext {
  VMessageTheme get vMessageTheme {
    final VMessageTheme? theme = Theme.of(this).extension<VMessageTheme>();
    if (theme == null) {
      if (Theme.of(this).brightness == Brightness.dark) {
        return VMessageTheme.dark();
      } else {
        return VMessageTheme.light();
      }
    }
    return theme;
  }
}

extension VMessageThemeNewExt on BuildContext {
  VBaseMessageTheme get vMessageThemeNew {
    if (VInheritedMessageTheme.of(this) == null) {
      if (isDark) {
        return VDarkMessageTheme();
      } else {
        return VLightMessageTheme();
      }
    }
    return VInheritedMessageTheme.of(this)!.theme;
  }
}
