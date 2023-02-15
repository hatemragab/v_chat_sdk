// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_sample/app/modules/home_tabs/settings_tab/views/widgets/profile_item.dart';

import '../controllers/settings_tab_controller.dart';

class SettingsTabView extends GetView<SettingsTabController> {
  const SettingsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 180,
                width: 180,
              ),
              const SizedBox(
                height: 20,
              ),
              "Welcome to V Chat v2.0".h6.alignCenter,
              const SizedBox(
                height: 20,
              ),
              ProfileItem(
                title: "My orders",
                onPress: controller.goToOrders,
                iconData: Icons.shopping_cart,
              ),
              const SizedBox(
                height: 20,
              ),
              ProfileItem(
                title: "Update language",
                onPress: controller.updateLanguage,
                iconData: Icons.language,
              ),
              ProfileItem(
                title: "Change theme",
                onPress: controller.changeTheme,
                iconData: Icons.sunny,
              ),
              ProfileItem(
                title: "Update profile",
                onPress: controller.updateProfile,
                iconData: Icons.edit,
              ),
              ProfileItem(
                title: "App notifications",
                onPress: controller.updateNotification,
                iconData: Icons.notification_add,
              ),
              ProfileItem(
                title: "V Chat documentation",
                onPress: controller.openDocs,
                iconData: Icons.file_copy,
              ),
              ProfileItem(
                title: "Contact me if you have any question",
                onPress: controller.openContactMe,
                iconData: Icons.chat,
              ),
              ProfileItem(
                title: "About",
                onPress: controller.openAbout,
                iconData: Icons.info_outline,
              ),
              ProfileItem(
                title: "V Chat v2 terms",
                onPress: controller.openTerms,
                iconData: Icons.file_present_rounded,
              ),
              ProfileItem(
                title: "Log out",
                onPress: controller.logout,
                iconData: Icons.exit_to_app,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
