import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

import './screens/splash_screen.dart';
import 'controllers/app_controller.dart';
import 'generated/l10n.dart';

class VChatCustomWidgets extends VChatWidgetBuilder {
  @override
  Color sendButtonColor(BuildContext context, bool isDark) {
    if (isDark) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  // http://170.178.195.150:81/
  await VChatController.instance.init(
    baseUrl: Uri.parse("http://170.178.195.150:81"),
    appName: "test_v_chat",
    isUseFirebase: true,
    widgetsBuilder: VChatCustomWidgets(),
    enableLogger: true,
    maxMediaUploadSize: 50 * 1000 * 1000,
    passwordHashKey: "passwordHashKey",

  );

  // add support new language
  // v_chat will change the language one you change it
  VChatController.instance.setLocaleMessages(
      languageCode: "ar", countryCode: "EG", lookupMessages: ArLanguage());

  // VChatController.instance.forceLanguage(languageCode: "ar",countryCode:'EG');

  runApp(ChangeNotifierProvider<AppController>(
    create: (context) => AppController(),
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
    context.watch<AppController>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.read<AppController>().theme,
      darkTheme: ThemeData.dark(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: context.read<AppController>().locale,
      home: const SplashScreen(),
    );
  }
}
