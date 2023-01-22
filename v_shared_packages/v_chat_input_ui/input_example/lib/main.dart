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
        extensions: [
          VInputTheme.light(cameraIcon: const Icon(Icons.camera)),
        ],
      ),
      darkTheme: ThemeData.dark().copyWith(
        extensions: [
          VInputTheme.dark(
            cameraIcon: const Icon(
              Icons.camera,
              color: Colors.green,
            ),
            containerDecoration: BoxDecoration(color: Colors.black54),
            recordBtn: Icon(Icons.ac_unit),
            sendBtn: Icon(Icons.search),
          ),
        ],
      ),
    ),
  );
}
