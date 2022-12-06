import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/lazy_inject.dart';
import 'app/core/utils/app_pref.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "V Chat V2",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      initialBinding: LazyInjection(),
      theme: FlexThemeData.light(
        scheme: FlexScheme.green,
        useMaterial3: true,
        appBarElevation: 20,
      ),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.green,
        useMaterial3: true,
        appBarElevation: 20,
      ),
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.system,
    );
  }
}
