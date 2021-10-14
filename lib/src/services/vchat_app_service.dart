import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk/src/utils/helpers/helpers.dart';
import 'package:v_chat_sdk/src/utils/translator/ar_language.dart';
import 'package:v_chat_sdk/src/utils/translator/en_language.dart';
import '../../v_chat_sdk.dart';
import '../models/v_chat_user.dart';
import '../sqlite/db_provider.dart';
import '../utils/get_storage_keys.dart';
import '../utils/vchat_constants.dart';

class VChatAppService extends GetxService {
  static final VChatAppService to = Get.find();

  VChatUser? vChatUser;
  Map<String, String>? trans;

  late String currentLocal;
  ThemeData? light;
  ThemeData? dark;
  GlobalKey<NavigatorState>? navKey;

  ThemeData? currentTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  LookupString getTrans([BuildContext? context]) {
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

  final Map<String, LookupString> _lookupMessagesMap = {
    'en': EnLanguage(),
    'ar_EG': ArLanguage()
  };

  void setLocaleMessages(String locale, LookupString lookupMessages) {
    _lookupMessagesMap[locale] = lookupMessages;
  }

  Future<VChatAppService> init() async {
    await GetStorage.init();
    await DBProvider.db.database;
    if (vchatUseFirebase) {
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
