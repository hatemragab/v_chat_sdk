import 'package:flutter/material.dart';

import 'message_item_theme.dart';

class VMessageTheme extends ThemeExtension<VMessageTheme> {
  final VMessageItemBuilder vMessageItemBuilder;
  final BoxDecoration scaffoldDecoration;

  VMessageTheme._({
    required this.vMessageItemBuilder,
    required this.scaffoldDecoration,
  });

  factory VMessageTheme.light() {
    return VMessageTheme._(
      vMessageItemBuilder: VMessageItemBuilder.light(),
      scaffoldDecoration: const BoxDecoration(),
    );
  }

  factory VMessageTheme.dark() {
    return VMessageTheme._(
      vMessageItemBuilder: VMessageItemBuilder.dark(),
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

  VMessageTheme copyWith({
    VMessageItemBuilder? vMessageItemBuilder,
    BoxDecoration? scaffoldDDecoration,
  }) {
    return VMessageTheme._(
      vMessageItemBuilder: vMessageItemBuilder ?? this.vMessageItemBuilder,
      scaffoldDecoration: scaffoldDDecoration ?? this.scaffoldDecoration,
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
