import 'package:flutter/material.dart';

class ColorBuilder {
  const ColorBuilder({
    required this.seenMessageIconColor,
  });

  const ColorBuilder.light() : seenMessageIconColor = Colors.black;

  const ColorBuilder.dark() : seenMessageIconColor = Colors.white;

  final Color seenMessageIconColor;

  ColorBuilder copyWith({
    Color? seenMessageIconColor,
  }) {
    return ColorBuilder(
      seenMessageIconColor: seenMessageIconColor ?? this.seenMessageIconColor,
    );
  }
}
