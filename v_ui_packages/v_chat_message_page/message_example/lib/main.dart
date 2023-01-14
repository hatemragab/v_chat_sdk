import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await VChatController.init(
  //   vChatConfig: VChatConfig(
  //     passwordHashKey: "YOUR STRONG PASSWORD HASH KEY!",
  //     baseUrl: Uri.parse("http://10.0.2.2:3000"),
  //   ),
  // );

  await VChatController.I.authApi.login(
    identifier: "user1@gmail.com",
    deviceLanguage: Locale("en"),
  );

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: Locale("en"),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    ),
  );
}
