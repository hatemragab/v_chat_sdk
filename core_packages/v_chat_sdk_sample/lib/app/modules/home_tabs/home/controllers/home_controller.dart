// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_receive_share/v_chat_receive_share.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../core/enums.dart';
import '../../../../core/utils/app_pref.dart';

class HomeController extends GetxController {
  int tabIndex = 0;
  final pageController = PageController();

  void updateIndex(int i) {
    tabIndex = i;
    pageController.animateToPage(i,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    update();
  }

  @override
  void onInit() {
    _setUpVChat();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    vInitReceiveShareHandler();
    getC();
  }

  void onPageChanged(int i) {
    tabIndex = i;
    update();
  }

  void getC() async {
    // final x = await VChatController.I.roomApi.getCallHistory();
    // print(x);
  }

  void _setUpVChat() async {
    final data = AppPref.getMap(SStorageKeys.myProfile.name);
    VChatController.I.profileApi.connect(
      identifier: data!['identifier'],
      fullName: null,
    );
  }
}
