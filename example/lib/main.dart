import 'package:bot_toast/bot_toast.dart';
import 'package:example/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import 'controllers/lang_controller.dart';
import 'generated/l10n.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// real server ip 18.216.232.131:3000
  await VChatController.instance.init(
      baseUrl: "192.168.1.4:3000",
      appName: "test_v_chat",
      isUseFirebase: true,
      lightTheme: vChatLightTheme,
      darkTheme: vChatDarkTheme,
      enableLogger: true,
      navKey: navigatorKey);

  // add support new language
  // v_chat will change the language one you change it
  // VChatController.instance.setLocaleMessages(
  //     languageCode: "ar", countryCode: "EG", lookupMessages: Ar());

  runApp(ChangeNotifierProvider<LangController>(
    create: (context) => LangController(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    context.watch<LangController>();
    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible) {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      }
    });
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
      home: SplashScreen(),
    );
  }
}
