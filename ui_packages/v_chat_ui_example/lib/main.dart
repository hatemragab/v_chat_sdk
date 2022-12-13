import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/v_chat_ui.dart';

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
      theme: FlexThemeData.light(
        scheme: FlexScheme.green,
        useMaterial3: true,
        appBarElevation: 20,
      ),
      builder: (context, child) {
        return VTheme(
          dataDark: VThemeData.dark(context: context),
          dataLight: VThemeData.light(context: context),
          brightness: Theme.of(context).brightness,
          child: Portal(child: child!),
        );
      },
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
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.green,
        useMaterial3: true,
        appBarElevation: 20,
      ),
    ),
  );
}
