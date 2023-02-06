import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_web_rtc/v_chat_web_rtc.dart';

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
  vInitCallListener();
    super.onInit();
  }
  void onPageChanged(int i) {
    tabIndex = i;
    update();
  }
}
