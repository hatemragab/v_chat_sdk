import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v_chat_sdk/src/utils/helpers/helpers.dart';
import 'package:v_chat_sdk/src/utils/translator/ar_language.dart';
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
    final local = Localizations.localeOf(context!).toString();
    currentLocal = local;
    if (_lookupMessagesMap[local] == null) {
      Helpers.vlog(
          "failed to find the language $local in v_chat_sdk please add it by use  VChatController.instance.setLocaleMessages() now will use english");
      return EnLanguage();
    } else {
      return _lookupMessagesMap[local]!;
    }
  }

  final Map<String, VChatLookupString> _lookupMessagesMap = {
    'en': EnLanguage(),
    'ar_EG': ArLanguage()
  };

  void setLocaleMessages(String locale, VChatLookupString lookupMessages) {
    _lookupMessagesMap[locale] = lookupMessages;
  }

  Future<VChatAppService> init(bool isUseFirebase) async {
    await GetStorage.init();
    await DBProvider.db.database;
    if (isUseFirebase) {
      await Firebase.initializeApp();
    }
    final userMap = GetStorage().read(GetStorageKeys.KV_CHAT_MY_MODEL);
    if (userMap != null) {
      vChatUser = VChatUser.fromMap(userMap);
    } else {
      vChatUser = null;
    }
    return this;
  }

  void setUser(VChatUser user) {
    vChatUser = user;
  }
}
