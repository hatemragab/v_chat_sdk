import 'package:example/utils/br_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import './screens/splash_screen.dart';
import 'controllers/app_controller.dart';
import 'controllers/home_controller.dart';
import 'generated/l10n.dart';
import 'utils/v_chat_utils/v_chat_custom_widgets.dart';

const isUseRealServer = true;

const serverIp =
    isUseRealServer ? "https://test.vchatsdk.com" : "http://10.0.2.2:3001";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await VChatController.instance.init(
    baseUrl: Uri.parse(serverIp),
    appName: "test_v_chat",
    vChatNotificationType: VChatNotificationType.none,
    widgetsBuilder: VChatCustomWidgets(),
    enableLogger: true,
    maxMediaUploadSize: 50 * 1000 * 1000,
    passwordHashKey: "passwordHashKey",
    maxGroupChatUsers: 512,
  );

  /// add support new language
  /// v_chat will change the language one you change it
  VChatController.instance.setLocaleMessages(vChatAddLanguageModel: [
    VChatAddLanguageModel(
      languageCode: "ar",
      countryCode: "EG",
      lookupMessages: ArLanguage(),
    ),
    VChatAddLanguageModel(
      languageCode: "pt",
      countryCode: "BR",
      lookupMessages: BrLanguage(),
    ),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppController>(
          create: (context) => AppController(),
        ),
        ChangeNotifierProvider<HomeController>(
          create: (context) => HomeController(),
          lazy: true,
        ),
      ],
      builder: (context, child) => MyApp(),
    ),
  );
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
