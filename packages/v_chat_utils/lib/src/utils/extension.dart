import 'package:flutter/material.dart';

import '../../v_chat_utils.dart';

extension on Duration {
  String format() => '$this'.split('.')[0].padLeft(8, '0');
}

extension MediaQueryExt2 on BuildContext {
  bool get isDark => platformBrightness == Brightness.dark;

  Future<T?> toPage<T>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  bool get isRtl => Directionality.of(this).name.toLowerCase() == "rtl";
}
