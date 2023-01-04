import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/modules/auth/authenticate.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkUser();
  }

  void checkUser() async {
    VChatController.I.setNavContext(Get.context!);
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Go to login
      AuthRepo.isAuth.value = false;
      Get.offAndToNamed(Routes.REGISTER);
    } else {
      AuthRepo.isAuth.value = true;
      Get.offAndToNamed(Routes.HOME);
    }
  }
}
