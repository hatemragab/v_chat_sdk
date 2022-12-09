import 'package:animated_login/animated_login.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FlexThemeData.dark(
        scheme: FlexScheme.green,
        useMaterial3: true,
        appBarElevation: 20,
      ),
      child: AnimatedLogin(
        onLogin: controller.onLogin,
        onSignup: controller.onSignup,
        logo: Image.asset('assets/images/logo.png'),
        // backgroundImage: 'images/background_image.jpg',
        signUpMode: SignUpModes.both,
        validateName: false,

        socialLogins: _socialLogins(context),
        nameValidator: const ValidatorModel(
          checkLowerCase: false,
          checkNumber: false,
          checkSpace: false,
          checkUpperCase: false,
          length: 8,
        ),
        emailValidator: ValidatorModel(
            validatorCallback: (String? email) => 'What an email! $email'),
        changeLanguageCallback: (LanguageOption? language) {
          if (language != null) {}
        },
        loginDesktopTheme: _desktopTheme,
        loginMobileTheme: _mobileTheme,
        passwordValidator: const ValidatorModel(
          checkLowerCase: false,
          checkNumber: false,
          checkSpace: false,
          checkUpperCase: false,
          length: 8,
        ),
        changeLangDefaultOnPressed: () async {},
        languageOptions: [LanguageOption(code: "en", value: "en")],
        selectedLanguage: LanguageOption(code: "en", value: "en"),
        initialMode: AuthMode.login,
        onAuthModeChange: (AuthMode newMode) async {
          // currentMode = newMode;
          // await _operation?.cancel();
        },
      ),
    );
  }

  LoginViewTheme get _desktopTheme => _mobileTheme.copyWith(
        // To set the color of button text, use foreground color.
        actionButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        dialogTheme: const AnimatedDialogTheme(
          languageDialogTheme: LanguageDialogTheme(
              optionMargin: EdgeInsets.symmetric(horizontal: 80)),
        ),
        loadingSocialButtonColor: Colors.blue,
        loadingButtonColor: Colors.white,
      );

  LoginViewTheme get _mobileTheme => LoginViewTheme(
        // showLabelTexts: false,
        backgroundColor: Colors.blueGrey,
        // // const Color(0xFF6666FF),
        // formFieldBackgroundColor: Colors.white,
        // formWidthRatio: 60,

        actionButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        animatedComponentOrder: const <AnimatedComponent>[
          AnimatedComponent(
            component: LoginComponents.logo,
            animationType: AnimationType.right,
          ),
          AnimatedComponent(component: LoginComponents.title),
          AnimatedComponent(component: LoginComponents.description),
          AnimatedComponent(component: LoginComponents.formTitle),
          AnimatedComponent(component: LoginComponents.socialLogins),
          AnimatedComponent(component: LoginComponents.useEmail),
          AnimatedComponent(component: LoginComponents.form),
          AnimatedComponent(component: LoginComponents.notHaveAnAccount),
          // AnimatedComponent(component: LoginComponents.forgotPassword),
          AnimatedComponent(component: LoginComponents.changeActionButton),
          AnimatedComponent(component: LoginComponents.actionButton),
        ],
      );

  List<SocialLogin> _socialLogins(BuildContext context) => <SocialLogin>[
        SocialLogin(
            callback: () async => _socialCallback('Google'),
            iconPath: 'assets/images/google.png'),
        SocialLogin(
            callback: () async => _socialCallback('Facebook'),
            iconPath: 'assets/images/facebook.png'),
      ];

  Future<String?> _socialCallback(String type) async {}
}
