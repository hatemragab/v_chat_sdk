import '../enums.dart';
import 'app_pref.dart';

abstract class AppLocalization {
  static String? get languageCode =>
      AppPref.getStringOrNull(StorageKeys.appLanguage);

  static Future<void> updateLanguageCode(String languageCode) =>
      AppPref.setString(StorageKeys.appLanguage, languageCode);
}
