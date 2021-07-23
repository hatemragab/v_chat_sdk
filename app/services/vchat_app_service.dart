import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';

import '../../vchat_constants.dart';
import '../models/vchat_user.dart';
import '../sqlite/db_provider.dart';
import '../utils/get_storage_keys.dart';

class VChatAppService extends GetxService {
  static VChatAppService to = Get.find();
  late Database database;
  VChatUser? vChatUser;

  Future<VChatAppService> init() async {
    await GetStorage.init();
    database = await DBProvider.db.database;
    if (USE_FIREBASE) {
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
