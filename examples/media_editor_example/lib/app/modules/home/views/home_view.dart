import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_media_editor/test.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MediaEditorTest();
  }
}
