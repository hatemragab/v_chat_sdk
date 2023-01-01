import 'dart:ui' as ui;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import 'app/core/app_service.dart';
import 'app/core/lazy_inject.dart';
import 'app/core/utils/app_localization.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: "https://qtkcgcmeqyyvhzvjebvr.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0a2NnY21lcXl5dmh6dmplYnZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzA1OTcyODgsImV4cCI6MTk4NjE3MzI4OH0.yaEOvgShEGTbv4ryYgeGZwK5oR1XOKNQOgs8R_xhq0E",
  );
  await VChatController.init(
    vChatConfig: VChatConfig(
      passwordHashKey: "YOUR STRONG PASSWORD HASH KEY!",
      baseUrl: _getBaseUrl(),
      pushProvider: VChatFcmProver(),
    ),
  );
  final appService = Get.put<AppService>(AppService());
  setAppTheme(appService);
  await setAppLanguage(appService);
  runApp(const MyApp());
}

Uri _getBaseUrl() {
  if (kDebugMode) {
    if (kIsWeb || VPlatforms.isIOS) {
      return Uri.parse("http://localhost:3000");
    }
    //this will only working on the android emulator
    //to test on real device get you ipv4 first google it ! how to get my ipv4
    return Uri.parse("http://10.0.2.2:3000");
  }
  return Uri.parse("http://v_chat_endpoint:3000");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GetBuilder<AppService>(
        assignId: true,
        builder: (appService) {
          return GetMaterialApp(
            title: "V Chat V2",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
            themeMode: appService.themeMode,
            initialBinding: LazyInjection(),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              VChatLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: appService.locale,
            fallbackLocale: const Locale("en"),
            theme: FlexThemeData.light(
                scheme: FlexScheme.green,
                useMaterial3: true,
                appBarElevation: 20,
                extensions: <ThemeExtension<dynamic>>[]),
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.green,
              useMaterial3: true,
              extensions: <ThemeExtension<dynamic>>[],
              appBarElevation: 20,
            ),
          );
        },
      ),
    );
  }
}

void setAppTheme(AppService appService) {
  final theme = VAppPref.getStringOrNull(VStorageKeys.appTheme);
  if (theme != null) {
    if (theme == ThemeMode.light.name) {
      appService.setTheme(ThemeMode.light);
    } else if (theme == ThemeMode.dark.name) {
      appService.setTheme(ThemeMode.dark);
    } else if (theme == ThemeMode.system.name) {
      appService.setTheme(ThemeMode.system);
    }
  }
}

Future<void> setAppLanguage(AppService appService) async {
  final languageCode = AppLocalization.languageCode;
  if (languageCode != null) {
    final locale = Locale.fromSubtags(
      languageCode: languageCode,
    );
    appService.setLocal(locale);
  } else {
    final languageCode = ui.window.locale.languageCode;
    final locale = Locale.fromSubtags(
      languageCode: languageCode,
    );
    appService.setLocal(locale);
    await AppLocalization.updateLanguageCode(languageCode);
  }
}
