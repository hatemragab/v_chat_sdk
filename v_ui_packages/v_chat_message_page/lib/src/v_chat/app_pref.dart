// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class VAppPref {
  static SharedPreferences get instance => VChatController.I.sharedPreferences;

  static String? getStringOrNullKey(String key) => instance.getString(key);

  static Future<void> setStringKey(
    String key,
    String value,
  ) {
    return instance.setString(key, value);
  }

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

  static Future<void> removeKey(
    String key,
  ) =>
      instance.remove(key);
}
