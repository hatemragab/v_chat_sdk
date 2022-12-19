import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onGallery,
        child: Text(
          "Open Gallery",
          textAlign: TextAlign.center,
        ),
      ),
      appBar: AppBar(
        title: const Text('Home View'),
        centerTitle: true,
      ),
    );
  }
}
