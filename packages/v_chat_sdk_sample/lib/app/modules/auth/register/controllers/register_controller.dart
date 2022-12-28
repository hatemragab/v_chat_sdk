import 'dart:ui';

import 'package:animated_login/src/models/login_data.dart';
import 'package:animated_login/src/models/signup_data.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../core/repository/user.repository.dart';
import '../../authenticate.dart';

class RegisterController extends GetxController {
  final UserRepository repository;

  RegisterController(this.repository);

  VPlatformFileSource? userImage;

  void getImage() async {
    final userImage = await VAppPick.getCroppedImage();
    if (userImage != null) {
      this.userImage = userImage;
    }
    update();
  }

  Future<String?> onLogin(LoginData loginData) async {
    try {
      final user = await AuthRepo.loginWithEmailAndPassword(
          loginData.email, loginData.password);
      final userFromFire = await repository.getId(user.uid);
      await VAppPref.setMap(VStorageKeys.myProfile, userFromFire.toMap());
      await VChatController.I.auth.login(
        identifier: userFromFire.id,
        deviceLanguage: const Locale("en"),
      );
      Get.offAndToNamed(Routes.HOME);
    } catch (err) {
      VAppAlert.showErrorSnackBar(msg: err.toString(), context: Get.context!);
      print(err);
      return err.toString();
    }
    return null;
  }

  Future<String?> onSignup(SignUpData signUpData) async {
    try {
      // AppAlert.showLoading();
      final user = await AuthRepo.signUpWithEmailAndPassword(
        emailAddress: signUpData.email,
        password: signUpData.password,
      );
      final userFromFire = UserModel(
        id: user.uid,
        userName: signUpData.name,
        createdAt: DateTime.now().toUtc(),
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/v-chat-sdk-v2.appspot.com/o/images%2Fdefault_user_image.png?alt=media&token=13bd6095-614f-42d2-a626-0fbbb0668d3c",
      );
      await repository.add(userFromFire);
      await VAppPref.setMap(VStorageKeys.myProfile, userFromFire.toMap());
      await VChatController.I.auth.register(
        identifier: userFromFire.id,
        fullName: userFromFire.userName,
        deviceLanguage: const Locale("en"),
      );
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

// import 'package:animated_login/src/models/login_data.dart';
// import 'package:animated_login/src/models/signup_data.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';
// import 'package:v_chat_utils/v_chat_utils.dart';
//
// import '../../../../core/repository/user.repository.dart';
// import '../../authenticate.dart';
//
// class RegisterController extends GetxController {
//   final UserRepository repository;
//
//   RegisterController(this.repository);
//
//   VPlatformFileSource? userImage;
//
//   void getImage() async {
//     final userImage = await VAppPick.getCroppedImage();
//     if (userImage != null) {
//       this.userImage = userImage;
//     }
//     update();
//   }
//
//   Future<String?> onLogin(LoginData loginData) async {
//     try {
//       final user = await AuthRepo.loginWithEmailAndPassword(
//         loginData.email,
//         loginData.password,
//       );
//       final userFromFire = await repository.getId(user.uid);
//
//       await VAppPref.setMap(VStorageKeys.myProfile, userFromFire.toMap());
//       Get.offAndToNamed(Routes.HOME);
//     } catch (err) {
//       VAppAlert.showErrorSnackBar(msg: err.toString(), context: Get.context!);
//       print(err);
//       return err.toString();
//     }
//     return null;
//   }
//
//   Future<String?> onSignup(SignUpData signUpData) async {
//     try {
//       final authRes = await Supabase.instance.client.auth.signUp(
//         email: signUpData.email,
//         password: signUpData.password,
//       );
//       final res = await Supabase.instance.client.from("users").insert({
//         "user_name": signUpData.name,
//         "image_url":
//             "https://qtkcgcmeqyyvhzvjebvr.supabase.co/storage/v1/object/sign/v.chat.v2/u.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJ2LmNoYXQudjIvdS5wbmciLCJ0cmFuc2Zvcm1hdGlvbnMiOiIiLCJpYXQiOjE2NzE5ODk3NjYsImV4cCI6MTk4NzM0OTc2Nn0.h91cn9O-p-sZHSe6jnBQUw5Wi-S3MLg_FwE_T-elPlU&download",
//       }).select();
//       await VAppPref.setMap(
//         VStorageKeys.myProfile,
//         (res as List).first as Map<String, dynamic>,
//       );
//       Get.offAndToNamed(Routes.HOME);
//     } catch (err) {
//       VAppAlert.showErrorSnackBar(msg: err.toString(), context: Get.context!);
//       print(err);
//       //AppAlert.hideLoading();
//       return err.toString();
//     }
//     return null;
//   }
// }
