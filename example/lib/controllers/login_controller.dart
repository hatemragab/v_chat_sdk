import 'package:example/models/user.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:example/utils/custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../screens/home.dart';
import '../screens/register_screen.dart';

class LoginController {
  BuildContext context;
  final emailTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();

  LoginController(this.context);

  void login() async {
    final email = emailTxtController.text.toString();
    final password = passwordTxtController.text.toString();
    try {
      final d = (await CustomDio().send(
              reqMethod: "post",
              path: "user/login",
              body: {"email": email, "password": password}))
          .data['data'];
      final u = User.fromMap(d);
      await VChatController.instance
          .login(VChatLoginDto(email: email, password: password));
      await GetStorage().write("myModel", u.toMap());
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Home(),
      ));
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
    }
  }

  void register() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RegisterScreen(),
    ));
  }
}
