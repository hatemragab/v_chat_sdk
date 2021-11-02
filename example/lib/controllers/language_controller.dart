import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {
  Locale locale = ui.window.locale;
  ThemeData theme = ThemeData.light();

  void changeTheme(bool isLight) {
    if (isLight) {
      theme = ThemeData.dark();
    } else {
      theme = ThemeData.light();
    }
    notifyListeners();
  }

  void setLocale(Locale value) {
    locale = value;
    notifyListeners();
  }
}
