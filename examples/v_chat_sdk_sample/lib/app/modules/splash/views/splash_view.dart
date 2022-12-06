import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("V Chat sdk v2"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20,
                ),
                const CircularProgressIndicator.adaptive(),
              ],
            ),
            const SizedBox(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: AppConstants.clintVersion.text,
            // ),
          ],
        ),
      ),
    );
  }
}
