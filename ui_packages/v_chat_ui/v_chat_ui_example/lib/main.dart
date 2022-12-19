import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import 'app/routes/app_pages.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await VChatController.init(
    vChatConfig: VChatConfig(
      passwordHashKey: "YOUR STRONG PASSWORD HASH KEY!",
      baseUrl: Uri.parse("http://10.0.2.2:3000"),
    ),
  );
  runApp(
    GetMaterialApp(
      title: "V Chat V2 ui",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      // themeMode: appService.themeMode,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      //  locale: appService.locale,
      fallbackLocale: const Locale("en"),
      // The Mandy red, dark theme.
      theme: FlexThemeData.light(
          scheme: FlexScheme.green,
          useMaterial3: true,
          appBarElevation: 20,
          useMaterial3ErrorColors: true,
          extensions: [VRoomTheme.light()]),
      darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.green,
          useMaterial3: true,
          appBarElevation: 20,
          useMaterial3ErrorColors: true,
          extensions: [VRoomTheme.dark()]),
    ),
  );
}
