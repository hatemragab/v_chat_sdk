// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class AppLanguage {
  final String language;
  final Locale locale;

  AppLanguage(this.language, this.locale);

  @override
  String toString() {
    return language;
  }
}

class AppTheme {
  final String theme;
  final ThemeMode mode;

  AppTheme(this.theme, this.mode);

  @override
  String toString() {
    return theme;
  }
}
