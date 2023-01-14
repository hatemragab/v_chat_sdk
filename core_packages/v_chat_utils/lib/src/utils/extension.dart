import 'package:flutter/material.dart';

extension MediaQueryExt2 on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Future<T?> toPage<T>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  bool get isRtl => Directionality.of(this).name.toLowerCase() == "rtl";
}
