// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_receive_share/v_chat_receive_share.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_web_rtc/v_chat_web_rtc.dart';

import '../../../logs/controllers/logs_controller.dart';

class HomeController extends GetxController {
  int tabIndex = 0;
  final pageController = PageController();
  final logger = Get.find<LogsController>();

  void updateIndex(int i) {
    tabIndex = i;
    pageController.animateToPage(i,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    update();
  }

  @override
  void onInit() {
    vInitCallListener();

    vRtcLoggerStream.stream.listen((event) {
      logger.logs.add(event);
    });
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
    final x = await VChatController.I.roomApi.getCallHistory();
    print(x);
  }
}
