import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HomeController extends GetxController {
  int tabIndex = 0;
  final pageController = PageController();
  StreamSubscription? vOnNotificationsClickedStream;

  void updateIndex(int i) {
    tabIndex = i;
    pageController.animateToPage(i,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    update();
  }

  void onPageChanged(int i) {
    tabIndex = i;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    vOnNotificationsClickedStream = VChatController
        .I.nativeApi.streams.vOnNotificationsClickedStream
        .listen(
      (event) {
        final room = event.room as VRoom;
        if (!VRoomTracker.instance.isRoomOpen(room.id)) {
          // Get.context!.toPage(VMessagePage(
          //   vRoom: room,
          // ));
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    vOnNotificationsClickedStream?.cancel();
  }
}
