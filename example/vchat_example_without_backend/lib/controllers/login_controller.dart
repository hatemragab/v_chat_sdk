import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:textless/textless.dart';
import 'package:vchat_test_3/screens/home.dart';
import 'package:vchat_test_3/vchat_package/app/dto/vchat_login_dto.dart';
import 'package:vchat_test_3/vchat_package/vchat_controller.dart';
import '../models/user.dart';
import '../screens/register.dart';

class LoginController {
  BuildContext context;
  final emailTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();

  LoginController(this.context);

  void showDialog1(String data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: "Error".text,
          content: data.text,
        );
      },
    );
  }

  void login() async {
    final email = emailTxtController.text.toString();
    final password = passwordTxtController.text.toString();
    try {
      final vChatUser = await VChatController.instance
          .login(VChatLoginDto(email: email, password: password));
      await GetStorage().write("myModel", vChatUser.toMap());
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Home(),
      ));
    } catch (err) {
      showDialog1(err.toString());
    }
  }

  void register() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RegisterScreen(),
    ));
  }
}
