import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import 'dart:ui' as ui;
import 'generated/l10n.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VChatController.instance.init(
    baseUrl: "10.0.2.2:3000",
    appName: "test_v_chat",
    isUseFirebase: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      theme: ThemeData.light(),
      navigatorObservers: [BotToastNavigatorObserver()],
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: _locale ?? ui.window.locale,
      home: Builder(builder: (context) {
        return VChatWrapper(
          child: const SplashScreen(),
          // translate the package
          trans: {"test": S.of(context).test, "offline": S.of(context).offline},
          dark: vchatDarkTheme,
          //custom theme
          light: vchatLightTheme.copyWith(
            textTheme: vchatLightTheme.textTheme.copyWith(

                headline6: vchatLightTheme.textTheme.headline6!
                    .copyWith(fontSize: 17)),
          ),
        );
      }),
    );
  }
}
