// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class AppLocalization {
  static String? get languageCode =>
      VAppPref.getStringOrNullKey(VStorageKeys.vAppLanguage.name);

  static Future<void> updateLanguageCode(String languageCode) =>
      VAppPref.setStringKey(VStorageKeys.vAppLanguage.name, languageCode);
}
