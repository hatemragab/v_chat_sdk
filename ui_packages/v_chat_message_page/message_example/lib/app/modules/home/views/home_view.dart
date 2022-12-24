import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMessagePage(
      vRoom: controller.vRoom,
      onMentionPress: (userId) {
        print("userId userId $userId");
      },
    );
  }
}
