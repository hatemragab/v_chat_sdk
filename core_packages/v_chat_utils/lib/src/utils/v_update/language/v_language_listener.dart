import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_utils/src/utils/app_pref.dart';
import 'package:v_chat_utils/src/utils/enums.dart';
import 'dart:ui' as ui;

class VLanguageListener extends ValueNotifier<Locale> {
  VLanguageListener._() : super(const Locale("en"));

  static final _instance = VLanguageListener._();

  static VLanguageListener get I {
    return _instance;
  }

  Future setLocal(Locale locale) async {
    await VAppPref.setStringKey(
      VStorageKeys.vAppLanguage.name,
      locale.toString(),
    );
    value = locale;
  }

  Locale get appLocal {
    final prefLang = VAppPref.getStringOrNullKey(
      VStorageKeys.vAppLanguage.name,
    );
    if (prefLang == null) {
      unawaited(setLocal(deviceLocal));
      return deviceLocal;
    }
    final split = prefLang.split("_");
    if (split.length == 1) {
      return Locale(split.first);
    } else {
      return Locale(split.first, split.last);
    }
  }

  Locale get deviceLocal => ui.window.locale;
}
