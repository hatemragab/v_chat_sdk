import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app/core/app_service.dart';
import 'app/core/enums.dart';
import 'app/core/lazy_inject.dart';
import 'app/core/utils/app_localization.dart';
import 'app/core/utils/app_pref.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppPref.init();
  final appService = Get.put<AppService>(AppService());
  setAppTheme(appService);
  await setAppLanguage(appService);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppService>(
      assignId: true,
      builder: (appService) {
        return GetMaterialApp(
          title: "V Chat V2",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          themeMode: appService.themeMode,
          initialBinding: LazyInjection(),
          theme: FlexThemeData.light(
            scheme: FlexScheme.green,
            useMaterial3: true,
            appBarElevation: 20,
          ),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: appService.locale,
          fallbackLocale: const Locale("en"),
          // The Mandy red, dark theme.
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.green,
            useMaterial3: true,
            appBarElevation: 20,
          ),
          // Use dark or light theme based on system setting.
        );
      },
    );
  }
}

void setAppTheme(AppService appService) {
  final theme = AppPref.getStringOrNull(StorageKeys.appTheme);
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
