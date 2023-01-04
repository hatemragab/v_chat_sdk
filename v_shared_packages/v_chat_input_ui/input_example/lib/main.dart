import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.light().copyWith(
        extensions: [VInputTheme.light(cameraIcon: const Icon(Icons.camera))],
      ),
      darkTheme: ThemeData.dark(),
    ),
  );
}
