import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  int tabIndex = 0;
  final pageController = PageController();

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
}
