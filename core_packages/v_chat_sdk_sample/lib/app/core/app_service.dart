// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppService extends GetxController {
  late Locale locale;

  ThemeMode themeMode = ThemeMode.system;

  void setLocal(Locale locale) {
    this.locale = locale;
    Get.locale = locale;
    Get.updateLocale(locale);
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
