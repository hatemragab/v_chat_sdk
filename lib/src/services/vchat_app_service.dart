import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import '../models/vchat_user.dart';
import '../sqlite/db_provider.dart';
import '../utils/get_storage_keys.dart';
import '../utils/vchat_constants.dart';

class VChatAppService extends GetxService {
  static VChatAppService to = Get.find();
  late Database database;
  VChatUser? vChatUser;
  Map<String, String>? trans;
  BuildContext? context;
  ThemeData? light;
  ThemeData? dark;

  ThemeData? currentTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  Future<VChatAppService> init() async {
    await GetStorage.init();
    database = await DBProvider.db.database;
    if (vchatUseFirebase) {
      await Firebase.initializeApp();
    }
    final userMap = GetStorage().read(GetStorageKeys.KV_CHAT_MY_MODEL);
    if (userMap != null) {
      vChatUser = VChatUser.fromMap(userMap);
    }
    return this;
  }

  void setUser(VChatUser user) {
    vChatUser = user;
  }
}
