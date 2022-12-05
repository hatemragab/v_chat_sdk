import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkUser();
  }

  void checkUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Go to login
      Get.offAndToNamed(Routes.REGISTER);
    } else {
      Get.offAndToNamed(Routes.HOME);
    }
  }
}
