import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'app/routes/app_pages.dart';

class FrLocalizations extends VChatLocalizationLabels {
  @override
  final String emailInputLabel;

  @override
  final String passwordInputLabel;

  @override
  final String registerActionText;

  @override
  final String signInActionText;

  const FrLocalizations({
    this.emailInputLabel = 'FrLocalizations',
    this.passwordInputLabel = 'FrLocalizations',
    this.signInActionText = 'FrLocalizations',
    this.registerActionText = 'FrLocalizations',
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const x = VChatLocalizations(
    Locale("fr"),
    FrLocalizations(),
  );
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      locale: const Locale('fr'),
      fallbackLocale: const Locale('ar'),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
      ],
      localizationsDelegates: [
        VChatLocalizations.withDefaultOverrides(
          const LabelOverrides(),
          const Locale("ar"),
        ),
        VChatLocalizations.addNewLocal(
          LabelFr(),
          const Locale("fr"),
        ),
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
        VChatLocalizations.delegate,
      ],
    ),
  );
}

class LabelOverrides extends ArLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'ادخل الايميل معدله';
}

class LabelFr extends VChatLocalizationLabels {
  @override
  String get emailInputLabel => "fr emailInputLabel";

  @override
  String get passwordInputLabel => "fr emailInputLabel";

  @override
  String get registerActionText => "fr emailInputLabel";

  @override
  String get signInActionText => "fr emailInputLabel";
}
