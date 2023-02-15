// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_chat_utils/src/utils/app_pref.dart';
import 'package:v_chat_utils/src/utils/enums.dart';

class VThemeListener extends ValueNotifier<ThemeMode> {
  VThemeListener._() : super(ThemeMode.system);

  static final _instance = VThemeListener._();

  static VThemeListener get I {
    return _instance;
  }

  Future setTheme(ThemeMode themeMode) async {
    await VAppPref.setStringKey(
      VStorageKeys.vAppTheme.name,
      themeMode.name,
    );
    value = themeMode;
  }

  ThemeMode get appTheme {
    final prefTheme = VAppPref.getStringOrNullKey(
      VStorageKeys.vAppTheme.name,
    );
    if (prefTheme == null) {
      unawaited(setTheme(themeLocal));
      return themeLocal;
    }
    return ThemeMode.values.byName(prefTheme);
  }

  ThemeMode get themeLocal => ThemeMode.system;
}
