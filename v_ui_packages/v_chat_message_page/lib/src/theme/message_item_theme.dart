// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

typedef MessageItemBuilderTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VBaseMessage data,
);

class VMessageItemTheme {
  final Widget Function(
    BuildContext context,
    DateTime dateTime,
    String dateString,
  )? dateDivider;
  final MessageItemBuilderTypeDef? replyMessageItemBuilder;

  const VMessageItemTheme._({
    this.dateDivider,
    this.replyMessageItemBuilder,
  });

  const VMessageItemTheme.light({
    this.dateDivider,
    this.replyMessageItemBuilder,
  });

  const VMessageItemTheme.dark({
    this.dateDivider,
    this.replyMessageItemBuilder,
  });

  VMessageItemTheme copyWith({
    Widget Function(
      BuildContext context,
      DateTime dateTime,
      String dateString,
    )? dateDivider,
    MessageItemBuilderTypeDef? replyMessageItemBuilder,
  }) {
    return VMessageItemTheme._(
      dateDivider: dateDivider ?? this.dateDivider,
      replyMessageItemBuilder:
          replyMessageItemBuilder ?? this.replyMessageItemBuilder,
    );
  }
}
