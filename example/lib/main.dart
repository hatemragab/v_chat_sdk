import 'package:bot_toast/bot_toast.dart';
import 'package:example/screens/splash_screen.dart';
import 'package:example/utils/ar_eg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import 'controllers/lang_controller.dart';
import 'generated/l10n.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//10.0.2.2
  /// real server ip 3.16.14.118:3000
  /// http://ec2-3-142-209-237.us-east-2.compute.amazonaws.com:3000
  await VChatController.instance.init(
    baseUrl: Uri.parse(
        "http://ec2-3-142-209-237.us-east-2.compute.amazonaws.com:3000"),
    appName: "test_v_chat",
    isUseFirebase: true,
    lightTheme: vChatLightTheme,
    darkTheme: vChatDarkTheme,
    enableLogger: true,
    navigatorKey: navigatorKey,
    maxMediaUploadSize: 50 * 1000 * 1000,
  );

  // add support new language
  // v_chat will change the language one you change it
  VChatController.instance.setLocaleMessages(
      languageCode: "ar", countryCode: "EG", lookupMessages: ArLanguage());

  runApp(ChangeNotifierProvider<LangController>(
    create: (context) => LangController(),
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
    context.watch<LangController>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: context.read<LangController>().theme,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      supportedLocales: S.delegate.supportedLocales,
      locale: context.read<LangController>().locale,
      home: const SplashScreen(),
    );
  }
}
