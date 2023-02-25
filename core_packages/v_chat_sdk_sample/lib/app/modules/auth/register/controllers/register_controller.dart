// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:animated_login/src/models/login_data.dart';
import 'package:animated_login/src/models/signup_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/core/enums.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class RegisterController extends GetxController {
  VPlatformFileSource? userImage;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void getImage() async {
    final userImage = await VAppPick.getCroppedImage();
    if (userImage != null) {
      this.userImage = userImage;
    }
    update();
  }

  @override
  onInit() {
    super.onInit();
    if (kDebugMode) {
      emailController.text = "user1@gmail.com";
      passwordController.text = "12345678";
    }
  }

  Future<String?> onLogin(LoginData loginData) async {
    try {
      // VChatController.I.
      final vUser = await VChatController.I.profileApi.login(
        identifier: loginData.email,
        deviceLanguage: const Locale("en"),
      );
      await VAppPref.setMap(SStorageKeys.myProfile.name, vUser.toMap());
      Get.offAndToNamed(Routes.HOME);
    } catch (err) {
      VAppAlert.showErrorSnackBar(msg: err.toString(), context: Get.context!);
      print(err);
      rethrow;
    }
    return null;
  }

  Future<String?> onSignup(SignUpData signUpData) async {
    try {
      final vUser = await VChatController.I.profileApi.register(
        identifier: signUpData.email,
        fullName: signUpData.name,
        deviceLanguage: const Locale("en"),
      );
      await VAppPref.setMap(SStorageKeys.myProfile.name, vUser.toMap());
      Get.offAndToNamed(Routes.HOME);
    } catch (err) {
      VAppAlert.showErrorSnackBar(msg: err.toString(), context: Get.context!);
      print(err);
      //AppAlert.hideLoading();
      return err.toString();
    }
    return null;
  }
}
