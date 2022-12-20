import 'package:v_chat_utils/v_chat_utils.dart';

abstract class AppLocalization {
  static String? get languageCode =>
      VAppPref.getStringOrNull(VStorageKeys.appLanguage);

  static Future<void> updateLanguageCode(String languageCode) =>
      VAppPref.setString(VStorageKeys.appLanguage, languageCode);
}
