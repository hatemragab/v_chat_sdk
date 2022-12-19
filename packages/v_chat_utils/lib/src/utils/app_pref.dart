import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enums.dart';

abstract class VAppPref {
  static late final SharedPreferences instance;

  static Future<void> init() async {
    instance = await SharedPreferences.getInstance();
  }

  static String? getStringOrNull(StorageKeys key) =>
      instance.getString(key.name);

  static String? getStringOrNullKey(String key) => instance.getString(key);

  static Future<void> setString(
    StorageKeys key,
    String value,
  ) {
    return instance.setString(key.name, value);
  }

  static Future<void> setStringKey(
    String key,
    String value,
  ) {
    return instance.setString(key, value);
  }

  static Future<void> setHashedString(
    StorageKeys sKey,
    String value,
  ) {
    final plainText = value;

    final key = Key.fromUtf8("%ROPEwalma1t3ri2[-parkHULU-;4vis");
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return instance.setString(sKey.name, encrypted.base64);
  }

  static String? getHashedString({
    required StorageKeys key,
    SharedPreferences? preferences,
  }) {
    late String? plainText;
    if (preferences != null) {
      plainText = preferences.getString(key.name);
    } else {
      plainText = instance.getString(key.name);
    }

    if (plainText == null) return null;
    final k = Key.fromUtf8("%ROPEwalma1t3ri2[-parkHULU-;4vis");
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(k));
    return encrypter.decrypt(Encrypted.fromBase64(plainText), iv: iv);
  }

  static bool isLogin() {
    return getBool(StorageKeys.isLogin);
  }

  static Future<void> setLogOut() {
    return remove(StorageKeys.isLogin);
  }

  static Future<void> setLogin() async {
    return setBool(StorageKeys.isLogin, true);
  }

  static int? getIntOrNull(
    String key,
  ) =>
      instance.getInt(key);

  static int getInt(
    String key, [
    int defult = 0,
  ]) =>
      getIntOrNull(key) ?? defult;

  static bool getBool(
    StorageKeys key,
  ) =>
      instance.getBool(key.name) ?? false;

  static Future<void> setInt(
    String key,
    int value,
  ) =>
      instance.setInt(key, value);

  static Future<void> setBool(
    StorageKeys key,
    // ignore: avoid_positional_boolean_parameters
    bool value,
  ) =>
      instance.setBool(key.name, value);

  static Map<String, dynamic>? getMap(
    StorageKeys key,
  ) {
    final data = getStringOrNull(key);
    return data == null ? null : jsonDecode(data) as Map<String, dynamic>;
  }

  static Map<String, dynamic>? getMapApiCache(
    String key,
  ) {
    final data = instance.getString(key);
    return data == null ? null : jsonDecode(data) as Map<String, dynamic>;
  }

  static Future<void> setMap(
    StorageKeys key,
    Map<String, dynamic> map,
  ) =>
      setString(key, jsonEncode(map));

  static Future<void> setMapApiCache(
    String key,
    Map<String, dynamic> map,
  ) =>
      instance.setString(key, jsonEncode(map));

  static Future<void> clear() => instance.clear();

  static Future<void> remove(
    StorageKeys key,
  ) =>
      instance.remove(key.name);

  static Future<void> removeKey(
    String key,
  ) =>
      instance.remove(key);
}
