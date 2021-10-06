import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LangController extends ChangeNotifier {
  int id = 0;
  Locale locale = ui.window.locale;
  ThemeData theme = ThemeData.light();

  void randomLocale() {
    ++id;
    if (id % 2 == 0) {
      locale = const Locale.fromSubtags(languageCode: "ar");
    } else {
      locale = const Locale.fromSubtags(languageCode: "en");
    }
    notifyListeners();
  }

  void  changeTheme(bool isLight) {
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
