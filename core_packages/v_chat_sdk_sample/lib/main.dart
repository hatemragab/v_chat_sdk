import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import 'app/core/app_service.dart';
import 'app/core/lazy_inject.dart';
import 'app/core/utils/app_localization.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(vFirebaseMessagingBackgroundHandler);
  await VChatController.init(
    navigatorKey: _navigatorKey,
    vChatConfig: VChatConfig(
      encryptHashKey: "V_CHAT_SDK_V2_VERY_STRONG_KEY",
      baseUrl: _getBaseUrl(),
      vPush: VPush(
        fcmProvider: VPlatforms.isMobile ? VChatFcmProver() : null,
        // oneSignalProvider: VPlatforms.isMobile
        //     ? VChatOneSignalProver(
        //         appId: VAppConstants.oneSignalAppId,
        //       )
        //     : null,
        enableVForegroundNotification: true,
        vPushConfig: VLocalNotificationPushConfig(),
      ),
    ),
    vNavigator: VNavigator(
      roomNavigator: roomDefaultNavigator,
      messageNavigator: messageDefaultNavigator,
    ),
    vMessagePageConfig: VMessagePageConfig(
      onMentionRequireSearch: (context, roomType, query) async {
        if (roomType == VRoomType.g) {
          ///enable mentions only for group chat
          return [
            VMentionModel(
              identifier: "identifier",
              name: "name",
              image:
                  "https://super-up-dev.s3.eu-west-3.amazonaws.com/default_user_image.png",
            ),
            VMentionModel(
              identifier: "identifier2",
              name: "name2",
              image:
                  "https://super-up-dev.s3.eu-west-3.amazonaws.com/default_user_image.png",
            ),
          ];
        }

        ///this mean stop mention!
        return [];
      },
      onMentionPress: (context, id) {
        print("id");
      },
    ),
  );
  final appService = Get.put<AppService>(AppService());
  setAppTheme(appService);
  await setAppLanguage(appService);
  runApp(const MyApp());
}

Uri _getBaseUrl() {
  // return Uri.parse("http://192.168.1.4:3001");
  if (kDebugMode) {
    if (kIsWeb || VPlatforms.isIOS) {
      return Uri.parse("http://localhost:3001");
    }
    //this will only working on the android emulator
    //to test on real device get you ipv4 first google it ! how to get my ipv4
    return Uri.parse("http://10.0.2.2:3001");
  }
  return Uri.parse("http://v_chat_endpoint:3001");
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
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              VTrans.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: appService.locale,
            fallbackLocale: const Locale("en"),
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.green,
            ),
            darkTheme: ThemeData.dark(),
          );
        },
      ),
    );
  }
}

void setAppTheme(AppService appService) {
  final theme = VAppPref.getStringOrNullKey(VStorageKeys.vAppTheme.name);
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
