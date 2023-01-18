import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../core/enums.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkUser();
  }

  void checkUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final myUser = VAppPref.getMap(SStorageKeys.myProfile.name);
    if (myUser == null) {
      // Go to login
      Get.offAndToNamed(Routes.REGISTER);
    } else {
      Get.offAndToNamed(Routes.HOME);
    }
  }
}
