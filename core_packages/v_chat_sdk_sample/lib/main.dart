// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/v_chat_config.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_platform/v_platform.dart';

import 'app/core/app_service.dart';
import 'app/core/lazy_inject.dart';
import 'app/core/utils/app_localization.dart';
import 'app/modules/logs/controllers/logs_controller.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class EnvironmentConfig {
  static const MAPS =
      String.fromEnvironment('maps', defaultValue: 'awesomeApp');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (VPlatforms.isMobile) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  FirebaseMessaging.onBackgroundMessage(vFirebaseMessagingBackgroundHandler);
  await initVChat(_navigatorKey);
  final appService = Get.put<AppService>(AppService());
  setAppTheme(appService);
  await setAppLanguage(appService);
  Get.put<LogsController>(
    LogsController(),
  );
  runApp(const MyApp());
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
              VTrans.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: appService.locale,
            fallbackLocale: const Locale("ar"),
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.green,
            ),
            darkTheme: ThemeData.dark().copyWith(extensions: [
              VMessageTheme.dark().copyWith(senderBubbleColor: Colors.red)
            ]),
          );
        },
      ),
    );
  }
}

void setAppTheme(AppService appService) {
  final theme = VAppPref.getStringOrNullKey(VStorageKeys.vAppTheme.name);
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
