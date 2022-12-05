import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';

import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScreen(
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20).copyWith(top: 40),
          child: Icon(
            Icons.lock,
            color: Colors.blue,
            size: constraints.maxWidth / 4 * (1 - shrinkOffset),
          ),
        );
      },
    );
  }
}
