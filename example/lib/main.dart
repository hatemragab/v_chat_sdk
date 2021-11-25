import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

import './screens/splash_screen.dart';
import 'controllers/language_controller.dart';
import 'generated/l10n.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // http://170.178.195.150:81/
  await VChatController.instance.init(
    baseUrl: Uri.parse("http://170.178.195.150:81"),
    appName: "test_v_chat",
    isUseFirebase: true,

    ///Edit Dark theme
    vChatDarkTheme: VChatTheme(
      vChatButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          ///button content padding
          padding: EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

          ///button background
          primary: Colors.red,

          ///button text color
          onPrimary: Colors.white,
        ),
      ),
        scaffoldBackgroundColor: Colors.blue
    ),
    vChatLightTheme: VChatTheme(),
    enableLogger: true,
    navigatorKey: navigatorKey,
    maxMediaUploadSize: 50 * 1000 * 1000,
  );

  // add support new language
  // v_chat will change the language one you change it
  VChatController.instance.setLocaleMessages(
      languageCode: "ar", countryCode: "EG", lookupMessages: ArLanguage());

  runApp(ChangeNotifierProvider<LanguageController>(
    create: (context) => LanguageController(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    context.watch<LanguageController>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: context.read<LanguageController>().theme,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: context.read<LanguageController>().locale,
      home: const SplashScreen(),
    );
  }
}
