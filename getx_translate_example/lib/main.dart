import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

import 'app/routes/app_pages.dart';
import 'lang/translation.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await VChatController.instance.init(
  //   baseUrl: Uri.parse("http://170.178.195.150:81"),
  //   appName: "test_v_chat",
  //   isUseFirebase: false,
  //   enableLogger: true,
  //   navigatorKey: navigatorKey,
  //   maxMediaUploadSize: 50 * 1000 * 1000,
  // );
  VChatController.instance
      .setLocaleMessages(languageCode: "ar", lookupMessages: ArLanguage());
  // await VChatController.instance
  //     .login(dto: VChatLoginDto(email: "testt", password: "testt"),context: context);
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translations: Translation(),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: Locale('ar'),
    ),
  );
}
