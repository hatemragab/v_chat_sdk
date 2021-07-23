import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  var _themeMode = ThemeMode.light;

  get getTheme => _themeMode;

  setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
