import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppService extends GetxController {
  late Locale locale;

  ThemeMode themeMode = ThemeMode.system;

  void setLocal(Locale locale) {
    this.locale = locale;
    Get.locale = locale;
    update();
  }

  String get getLangCode => locale.languageCode;

  void setTheme(ThemeMode themeType) {
    if (themeType == ThemeMode.light) {
      themeMode = ThemeMode.light;
    } else if (themeType == ThemeMode.dark) {
      themeMode = ThemeMode.dark;
    } else if (themeType == ThemeMode.system) {
      themeMode = ThemeMode.system;
    }
    update();
  }
}
