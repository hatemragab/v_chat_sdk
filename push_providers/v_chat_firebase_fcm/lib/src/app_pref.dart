// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class VAppPref {
  static SharedPreferences? _instance;

  static SharedPreferences get instance => _instance!;
  static late String _hashKey;

  static Future<void> init() async {
    const hasKey = "%ROPEwalma1t3ri2[-parkHULU-;4vis";
    _instance ??= await SharedPreferences.getInstance();
    _hashKey = "$hasKey%ROPEwalma1t3ri2[-parkHULU-;4vis".substring(0, 32);
  }

  static String? getStringOrNullKey(String key) => instance.getString(key);

  static Future<void> setStringKey(
    String key,
    String value,
  ) {
    return instance.setString(key, value);
  }

  static Future<void> setHashedString(
    String sKey,
    String value,
  ) {
    final plainText = value;

    final key = Key.fromUtf8(_hashKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return instance.setString(sKey, encrypted.base64);
  }

  static String? getHashedString({
    required String key,
    SharedPreferences? preferences,
  }) {
    late String? plainText;
    if (preferences != null) {
      plainText = preferences.getString(key);
    } else {
      plainText = instance.getString(key);
    }

    if (plainText == null) return null;
    final k = Key.fromUtf8(_hashKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(k));
    return encrypter.decrypt(Encrypted.fromBase64(plainText), iv: iv);
  }

  static bool isLogin() {
    return getBool("vIsLogin");
  }

  static int? getIntOrNull(
    String key,
  ) =>
      instance.getInt(key);

  static bool getBool(
    String key,
  ) =>
      instance.getBool(key) ?? false;

  static Future<void> setInt(
    String key,
    int value,
  ) =>
      instance.setInt(key, value);

  static Future<void> setBool(
    String key,
    // ignore: avoid_positional_boolean_parameters
    bool value,
  ) =>
      instance.setBool(key, value);

  static Map<String, dynamic>? getMap(
    String key,
  ) {
    final data = getStringOrNullKey(key);
    return data == null ? null : jsonDecode(data) as Map<String, dynamic>;
  }

  static Map<String, dynamic>? getMapApiCache(
    String key,
  ) {
    final data = instance.getString(key);
    return data == null ? null : jsonDecode(data) as Map<String, dynamic>;
  }

  static Future<void> setMap(
    String key,
    Map<String, dynamic> map,
  ) =>
      setStringKey(key, jsonEncode(map));

  static Future<void> setMapApiCache(
    String key,
    Map<String, dynamic> map,
  ) =>
      instance.setString(key, jsonEncode(map));

  static Future<void> clear() => instance.clear();

  static Future<void> removeKey(
    String key,
  ) =>
      instance.remove(key);
}
