import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegisterScreen(
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

      providerConfigs: [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId:
              '706118575283-m3bqqm62al2es7cvdic24jbg028tsrsd.apps.googleusercontent.com',
        ),
        FacebookProviderConfiguration(clientId: ''),
        PhoneProviderConfiguration(),
        AppleProviderConfiguration(),
      ],

      // ...
    );
  }
}
