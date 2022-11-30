import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VChatController.instance.init(
    config: VChatConfig(
      pushProvider: VChatFcmProver(),
      enableLog: true,
      passwordHashKey:
          "!nRVu@TqJY*UWI7^4Ery&Sz36BwQv%hf)Hk2LpmxdF8sNbtD9aG(jXAM#PKZCc)",
      baseUrl: Uri.parse("http://10.0.2.2"),
    ),
  );
  final t = await VChatController.instance.login(
    identifier: "identifier",
    deviceLanguage: Locale("en"),
  );
  print(t);
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
