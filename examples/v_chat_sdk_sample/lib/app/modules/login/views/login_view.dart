import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      showAuthActionSwitch: false,
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            action == AuthAction.signIn
                ? 'Welcome to VCHAT Sdk v2 UI! Please sign in to continue.'
                : 'Welcome to VCHAT Sdk v2 UI! Please create an account to continue',
          ),
        );
      },
      footerBuilder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(top: 1),
          child: Column(
            children: [
              TextButton(
                  onPressed: () => Get.toNamed(Routes.REGISTER),
                  child: Text("Register")),
              Text(
                'By signing in, you agree to our terms and conditions.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
      // sideBuilder: (context, constraints) {},
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              'https://firebase.flutter.dev/img/flutterfire_300x.png',
            ),
          ),
        );
      },
      actions: [
        ForgotPasswordAction(
          (context, email) {
            Get.toNamed(Routes.FORGET_PASSWORD);
          },
        )
      ],

      providerConfigs: const [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId:
              '706118575283-m3bqqm62al2es7cvdic24jbg028tsrsd.apps.googleusercontent.com',
        ),
        FacebookProviderConfiguration(clientId: ''),
        PhoneProviderConfiguration(),
        AppleProviderConfiguration(),
      ],
    );
  }
}
