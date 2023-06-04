// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

extension MediaQueryExt2 on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Future<T?> toPage<T>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

  Future<T?> toPageAndRemoveAll<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false);
  }

  bool get isRtl => Directionality.of(this).name.toLowerCase() == "rtl";
}
