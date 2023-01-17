import 'package:v_chat_utils/v_chat_utils.dart';

abstract class AppLocalization {
  static String? get languageCode =>
      VAppPref.getStringOrNullKey(VStorageKeys.vAppLanguage.name);

  static Future<void> updateLanguageCode(String languageCode) =>
      VAppPref.setStringKey(VStorageKeys.vAppLanguage.name, languageCode);
}
