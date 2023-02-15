// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/modules/home_tabs/chats_tab/views/chats_tab_view.dart';
import 'package:v_chat_sdk_sample/app/modules/home_tabs/explore_tab/views/explore_tab_view.dart';
import 'package:v_chat_sdk_sample/app/modules/home_tabs/settings_tab/views/settings_tab_view.dart';
import 'package:v_chat_sdk_sample/app/modules/home_tabs/users_tab/views/users_tab_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;

  @override
  void initState() {
    controller = Get.find<HomeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          children: <Widget>[
            ExploreTabView(),
            UsersTabView(),
            ChatsTabView(),
            SettingsTabView()
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<HomeController>(
        assignId: true,
        builder: (logic) {
          return BottomNavyBar(
            selectedIndex: controller.tabIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: controller.updateIndex,
            items: [
              BottomNavyBarItem(
                icon: const Icon(Icons.apps),
                title: const Text('Home'),
                activeColor: Colors.green,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.people),
                title: const Text('Users'),
                activeColor: Colors.green,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.message),
                title: const Text('Messages'),
                activeColor: Colors.green,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.settings),
                title: const Text('Settings'),
                activeColor: Colors.green,
              ),
            ],
          );
        },
      ),
    );
  }
}
