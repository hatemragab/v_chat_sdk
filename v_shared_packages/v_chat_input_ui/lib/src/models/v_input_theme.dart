// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VInputTheme extends ThemeExtension<VInputTheme> {
  final BoxDecoration containerDecoration;
  final InputDecoration textFieldDecoration;

  final Widget cameraIcon;
  final Widget fileIcon;
  final Widget emojiIcon;
  final Widget trashIcon;

  Widget? recordBtn;
  Widget? sendBtn;
  final TextStyle textFieldTextStyle;

  VInputTheme._({
    required this.containerDecoration,
    required this.textFieldDecoration,
    required this.recordBtn,
    required this.sendBtn,
    required this.textFieldTextStyle,
    required this.emojiIcon,
    required this.trashIcon,
    required this.fileIcon,
    required this.cameraIcon,
  });

  VInputTheme.light({
    this.containerDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    this.cameraIcon = const Icon(
      PhosphorIcons.camera,
      size: 26,
      color: Colors.green,
    ),
    this.trashIcon = const Icon(
      PhosphorIcons.trash,
      color: Colors.redAccent,
      size: 30,
    ),
    this.fileIcon = const Icon(
      PhosphorIcons.paperclip,
      size: 26,
      color: Colors.green,
    ),
    this.emojiIcon = const Icon(
      PhosphorIcons.smiley,
      size: 26,
      color: Colors.green,
    ),
    this.textFieldDecoration = const InputDecoration(
      border: InputBorder.none,
      fillColor: Colors.transparent,
    ),
    this.recordBtn,
    this.sendBtn,
    this.textFieldTextStyle = const TextStyle(height: 1.3),
  }) {
    recordBtn ??= Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: const Icon(
        PhosphorIcons.microphoneFill,
        color: Colors.white,
      ),
    );
    sendBtn ??= Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: const Icon(
        Icons.send,
        color: Colors.white,
      ),
    );
  }

  VInputTheme.dark({
    this.containerDecoration = const BoxDecoration(
      color: Color(0xf7232121),
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    this.trashIcon = const Icon(
      PhosphorIcons.trash,
      color: Colors.redAccent,
      size: 30,
    ),
    this.cameraIcon = const Icon(
      PhosphorIcons.camera,
      size: 26,
      color: Colors.green,
    ),
    this.fileIcon = const Icon(
      PhosphorIcons.paperclip,
      size: 26,
      color: Colors.green,
    ),
    this.emojiIcon = const Icon(
      PhosphorIcons.smiley,
      size: 26,
      color: Colors.green,
    ),
    this.textFieldDecoration = const InputDecoration(
      border: InputBorder.none,
      fillColor: Colors.transparent,
    ),
    this.recordBtn,
    this.textFieldTextStyle = const TextStyle(height: 1.3),
    this.sendBtn,
  }) {
    recordBtn ??= Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: const Icon(
        PhosphorIcons.microphoneFill,
        color: Colors.white,
      ),
    );
    sendBtn ??= Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: const Icon(
        Icons.send,
        color: Colors.white,
      ),
    );
  }

  @override
  ThemeExtension<VInputTheme> lerp(
      ThemeExtension<VInputTheme>? other, double t) {
    if (other is! VInputTheme) {
      return this;
    }
    return this;
  }

  @override
  VInputTheme copyWith({
    BoxDecoration? containerDecoration,
    InputDecoration? textFieldDecoration,
    Widget? cameraIcon,
    Widget? fileIcon,
    Widget? emojiIcon,
    Widget? recordBtn,
    Widget? sendBtn,
    Widget? trashIcon,
    TextStyle? textFieldTextStyle,
  }) {
    return VInputTheme._(
      containerDecoration: containerDecoration ?? this.containerDecoration,
      textFieldDecoration: textFieldDecoration ?? this.textFieldDecoration,
      cameraIcon: cameraIcon ?? this.cameraIcon,
      fileIcon: fileIcon ?? this.fileIcon,
      trashIcon: trashIcon ?? this.trashIcon,
      emojiIcon: emojiIcon ?? this.emojiIcon,
      recordBtn: recordBtn ?? this.recordBtn,
      sendBtn: sendBtn ?? this.sendBtn,
      textFieldTextStyle: textFieldTextStyle ?? this.textFieldTextStyle,
    );
  }
}

extension VInputThemeExt on BuildContext {
  VInputTheme get vInputTheme {
    final VInputTheme? theme = Theme.of(this).extension<VInputTheme>();
    if (theme == null) {
      if (Theme.of(this).brightness == Brightness.dark) {
        return VInputTheme.dark();
      } else {
        return VInputTheme.light();
      }
    }
    return theme;
  }
}
