import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {
  final isEn = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // VChatController.instance.bindChatControllers(
    //
    // );
  }

  void changeLang(bool value) {
    isEn.value = !isEn.value;
    if (isEn.isTrue) {
      Get.updateLocale(Locale("ar", "EG"));
    } else {
      Get.updateLocale(Locale("en"));
    }
  }
}
