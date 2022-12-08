import 'package:flutter/cupertino.dart';
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
