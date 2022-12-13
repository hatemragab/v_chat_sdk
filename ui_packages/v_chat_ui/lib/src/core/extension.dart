import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';

extension MediaQueryExt2 on BuildContext {
  bool get isDark => platformBrightness == Brightness.dark;

  Future<T?> toPage<T>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
}
