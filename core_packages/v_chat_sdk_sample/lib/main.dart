// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_sample/v_chat_config.dart';
import 'package:v_platform/v_platform.dart';

import 'app/core/app_service.dart';
import 'app/core/enums.dart';
import 'app/core/lazy_inject.dart';
import 'app/core/utils/app_localization.dart';
import 'app/core/utils/app_pref.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class EnvironmentConfig {
  static const MAPS =
      String.fromEnvironment('maps', defaultValue: 'awesomeApp');
}

void main() async {
  // Initialize the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the platform is mobile and initialize Firebase if it is.
  if (VPlatforms.isMobile) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  await AppPref.init();
  // Initialize the background message handler for FCM.
  FirebaseMessaging.onBackgroundMessage(vFirebaseMessagingBackgroundHandler);

  // Initialize VChat.
  await initVChat(_navigatorKey);

  // Initialize the AppService.
  final appService = Get.put<AppService>(AppService());

  // Set the app theme.
  setAppTheme(appService);

  // Set the app language.
  await setAppLanguage(appService);

  // Run the app.
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
          navigatorKey: _navigatorKey,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertino,
          debugShowCheckedModeBanner: false,
          themeMode: appService.themeMode,
          initialBinding: LazyInjection(),
          builder: (context, child) {
            return Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     Get.toNamed(Routes.LOGS);
              //   },
              //   child: Icon(Icons.light),
              // ),
              body: child!,
            );
          },
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: Get.locale,
          fallbackLocale: const Locale("en"),
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,
          ),
          darkTheme: ThemeData.dark().copyWith(
            extensions: [
              VMessageTheme.dark().copyWith(senderBubbleColor: Colors.red)
            ],
          ),
        );
      },
    );
  }
}

void setAppTheme(AppService appService) {
  final theme = AppPref.getStringOrNullKey(SStorageKeys.appTheme.name);
  if (theme != null) {
    appService.setTheme(theme as ThemeMode);
  }
}

Future<void> setAppLanguage(final AppService appService) async {
  String? languageCode = AppLocalization.languageCode;
  Locale locale;

  if (languageCode != null) {
    locale = Locale.fromSubtags(languageCode: languageCode);
  } else {
    languageCode = ui.window.locale.languageCode;
    locale = Locale.fromSubtags(languageCode: languageCode);
    AppLocalization.updateLanguageCode(languageCode);
  }

  appService.setLocal(locale);
}
