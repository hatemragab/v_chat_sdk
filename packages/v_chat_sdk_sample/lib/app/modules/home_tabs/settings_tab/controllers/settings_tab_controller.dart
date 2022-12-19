import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/app_service.dart';
import 'package:v_chat_sdk_sample/app/modules/auth/authenticate.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../core/utils/app_localization.dart';
import '../models.dart';

class SettingsTabController extends GetxController {
  final AppService appService;

  SettingsTabController(this.appService);

  Future<void> updateLanguage() async {
    final res = await VAppAlert.showAskListDialog<AppLanguage>(
      title: "Choose language",
      context: Get.context!,
      content: <AppLanguage>[
        AppLanguage("العربيه", const Locale("ar")),
        AppLanguage("English", const Locale("en"))
      ],
    );
    if (res != null) {
      await AppLocalization.updateLanguageCode(res.locale.languageCode);
      appService.setLocal(res.locale);
    }
  }

  Future<void> changeTheme() async {
    final res = await VAppAlert.showAskListDialog<AppTheme>(
      title: "Choose Theme",
      content: [
        AppTheme(
          "Light",
          ThemeMode.light,
        ),
        AppTheme(
          "Dark",
          ThemeMode.dark,
        ),
        AppTheme(
          "System",
          ThemeMode.system,
        )
      ],
      context: Get.context!,
    );
    if (res != null) {
      await VAppPref.setString(
        StorageKeys.appTheme,
        res.mode.name,
      );
      appService.setTheme(res.mode);
    }
  }

  Future<void> updateProfile() async {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  Future<void> updateNotification() async {
    final res = await VAppAlert.showAskListDialog(
      title: "Choose language",
      context: Get.context!,
      content: ["Enable", "Stop"],
    );
    print(res);
  }

  Future<void> openDocs() async {}

  Future<void> openContactMe() async {}

  Future<void> openAbout() async {
    Get.toNamed(Routes.ABOUT);
  }

  Future<void> openTerms() async {}

  Future<void> logout() async {
    final res = await VAppAlert.showAskYesNoDialog(
      //todo fix trnas
      title: "You are bout to logout",
      context: Get.context!,
      content: "Are you sure to logout ?",
    );
    if (res == 1) {
      await VAppPref.clear();
      await AuthRepo.logout();
      Get.offAndToNamed(Routes.SPLASH);
    }
  }

  void goToOrders() {
    Get.toNamed(Routes.MY_ORDERS);
  }
}
