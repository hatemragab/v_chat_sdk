// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import '../enums.dart';
import 'app_pref.dart';

abstract class AppLocalization {
  static String? get languageCode =>
      AppPref.getStringOrNullKey(SStorageKeys.appLanguage.name);

  static Future<void> updateLanguageCode(String languageCode) =>
      AppPref.setStringKey(SStorageKeys.appLanguage.name, languageCode);
}
