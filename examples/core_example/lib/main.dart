import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VChatController.instance.init(
    config: VChatConfig(
      passwordHashKey: "passwordHashKey",
      baseUrl: kIsWeb
          ? Uri.parse("http://localhost:3000")
          : Uri.parse("http://10.0.2.2:3000"),
    ),
  );
  runApp(
    GetMaterialApp(
      title: "Core Example",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
