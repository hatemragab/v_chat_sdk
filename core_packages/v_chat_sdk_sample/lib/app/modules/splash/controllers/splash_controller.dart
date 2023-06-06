// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

import '../../../core/enums.dart';
import '../../../core/utils/app_pref.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    checkUser();
  }

  void checkUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final myUser = AppPref.getMap(SStorageKeys.myProfile.name);
    if (myUser == null) {
      // Go to login
      Get.offAndToNamed(Routes.REGISTER);
    } else {
      Get.offAndToNamed(Routes.HOME);
    }
  }
}
