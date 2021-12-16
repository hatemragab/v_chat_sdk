import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../v_chat_sdk.dart';
import '../models/v_chat_user.dart';
import '../sqlite/db_provider.dart';
import '../utils/helpers/helpers.dart';
import '../utils/storage_keys.dart';

class VChatAppService {
  VChatAppService._privateConstructor();

  static final VChatAppService instance = VChatAppService._privateConstructor();

  VChatUser? vChatUser;
  Map<String, String>? trans;

  late VChatWidgetBuilder vcBuilder;
  late bool isUseFirebase;

  String currentLocal = "en";

  late String appName;
  late int maxGroupChatUsers;

  late bool enableLog;

  String? forceLanguage;

  late String passwordHashKey;

  VChatLookupString getTrans(BuildContext context) {
    /// languageCode is EN or AR etc...
    final locale = Localizations.localeOf(context);

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

    if (forceLanguage != null) {
      currentLocal = forceLanguage!;
    }

    if (_lookupMessagesMap[currentLocal] == null) {
      if (languageCode == "en") {
        return EnLanguage();
      }
      Helpers.vlog(
        "failed to find the language $currentLocal in v_chat_sdk please add it by use  VChatController.instance.setLocaleMessages() now will use english",
      );
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

  Future<VChatAppService> init({required bool isUseFirebase}) async {
    const storage = FlutterSecureStorage();

    await DBProvider.instance.database;
    if (isUseFirebase) {
      await Firebase.initializeApp();
    }

    final String? userJson = await storage.read(key: StorageKeys.kvChatMyModel);
    if (userJson != null) {
      vChatUser =
          VChatUser.fromMap(jsonDecode(userJson) as Map<String, dynamic>);
    } else {
      vChatUser = null;
    }
    return this;
  }

  void changeLanguage({required String languageCode, String? countryCode}) {
    if (countryCode != null) {
      forceLanguage = "${languageCode}_${countryCode.toUpperCase()}";
    } else {
      forceLanguage = languageCode;
    }
  }
}
