import 'package:core_example/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text("Http requestes"),
              leading: Icon(Icons.network_check_sharp),
              onTap: () => Get.toNamed(Routes.HTTP),
            ),
            ListTile(
              title: Text("Socket io"),
              leading: Icon(Icons.thunderstorm_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
