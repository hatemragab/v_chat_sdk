import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'.tr),
        actions: [
          Obx(
            () => Switch(
              value: controller.isEn.value,
              onChanged: controller.changeLang,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: VChatRoomsView(),
    );
  }
}
