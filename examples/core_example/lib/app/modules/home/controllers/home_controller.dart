import 'dart:ui';

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loginTest();
  }

  void loginTest() async {
    final loginRes = await VChatController.instance.login(
      identifier: "xxx",
      deviceLanguage: const Locale("en"),
    );
    print(loginRes);
  }
}
