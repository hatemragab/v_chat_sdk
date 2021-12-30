import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_chat_sdk/src/utils/storage_keys.dart';
import 'package:v_chat_sdk/src/utils/v_chat_config.dart';

class SharedPrefsInstance {
  SharedPrefsInstance._();

  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static Future setDefaultVersionValues() async {
    await Future.wait([
      instance.setString(
        StorageKeys.packageVersion,
        VChatConfig.packageVersion,
      ),
      instance.setInt(StorageKeys.databaseVersion, VChatConfig.databaseVersion),
      instance.setInt(StorageKeys.backendBuild, VChatConfig.backendBuild),
      instance.setString(
        StorageKeys.backendVersion,
        VChatConfig.backendVersion,
      ),
      instance.setString(StorageKeys.packageBuild, VChatConfig.packageVersion),
    ]);
  }

  static bool isLanguageChanged(String language) {
    final lng = instance.getString(StorageKeys.kvChatAppLanguage);
    if (lng != null) {
      if (language == lng) {
        return true;
      }
    }
    return false;
  }
}
