import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v_chat_sdk/src/utils/helpers/helpers.dart';
import 'package:v_chat_sdk/src/utils/translator/en_language.dart';
import '../../v_chat_sdk.dart';
import '../models/v_chat_user.dart';
import '../sqlite/db_provider.dart';
import '../utils/get_storage_keys.dart';

class VChatAppService extends GetxService {
  static final VChatAppService to = Get.find();

  VChatUser? vChatUser;
  Map<String, String>? trans;

  late String baseUrl;
  late bool isUseFirebase;

  late String currentLocal;
  ThemeData? light;
  ThemeData? dark;
  GlobalKey<NavigatorState>? navKey;

  late String appName;

  late bool enableLog;

  late int maxMediaSize;

  ThemeData? currentTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  VChatLookupString getTrans([BuildContext? context]) {
    context ??= navKey!.currentContext;

    /// languageCode is EN or AR etc...
    Locale locale = Localizations.localeOf(context!);

    ///check if user us getx or flutter localization
    if (Get.locale != null) {
      locale = Get.locale!;
    }

    ///countryCode is US or EG etc...
    final languageCode = locale.languageCode;
    final String? countryCode = locale.countryCode;
    late String fullLocalName;
    if (countryCode == null) {
      fullLocalName = languageCode;
    } else {
      fullLocalName = "${languageCode}_$countryCode";
    }
    currentLocal = fullLocalName;

    if (_lookupMessagesMap[currentLocal] == null) {
      if (languageCode == "en") {
        return EnLanguage();
      }
      // for (final lang in _lookupMessagesMap.entries) {
      //   final x = lang.key.split("_")[0];
      //   print(currentLocal +"  " + x);
      //   if(x == currentLocal){
      //     return _lookupMessagesMap[lang.key]!;
      //   }
      // }
      Helpers.vlog(
          "failed to find the language $currentLocal in v_chat_sdk please add it by use  VChatController.instance.setLocaleMessages() now will use english");
      return EnLanguage();
    } else {
      return _lookupMessagesMap[currentLocal]!;
    }
  }

  final Map<String, VChatLookupString> _lookupMessagesMap = {
    'en': EnLanguage()
  };

  void setLocaleMessages(String locale, VChatLookupString lookupMessages) {
    _lookupMessagesMap[locale] = lookupMessages;
  }

  Future<VChatAppService> init(bool isUseFirebase) async {
    const storage = FlutterSecureStorage();

    await DBProvider.db.database;
    if (isUseFirebase) {
      await Firebase.initializeApp();
    }
    await GetStorage.init();

    final String? userJson =
        await storage.read(key: StorageKeys.KV_CHAT_MY_MODEL);
    if (userJson != null) {
      vChatUser = VChatUser.fromMap(jsonDecode(userJson));
    } else {
      final getXData = GetStorage().read(StorageKeys.KV_CHAT_MY_MODEL);
      if (getXData != null) {
        vChatUser = VChatUser.fromMap(getXData);
        await storage.write(
          key: StorageKeys.KV_CHAT_MY_MODEL,
          value: jsonEncode(getXData),
        );
      } else {
        vChatUser = null;
      }
    }
    return this;
  }

  void setUser(VChatUser user) {
    vChatUser = user;
  }
}
