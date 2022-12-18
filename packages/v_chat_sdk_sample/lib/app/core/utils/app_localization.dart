import 'package:v_chat_utils/v_chat_utils.dart';

import '../enums.dart';

abstract class AppLocalization {
  static String? get languageCode =>
      AppPref.getStringOrNull(StorageKeys.appLanguage);

  static Future<void> updateLanguageCode(String languageCode) =>
      AppPref.setString(StorageKeys.appLanguage, languageCode);
}
