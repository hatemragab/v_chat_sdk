
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../models/user.dart';
import '../screens/home.dart';
import '../screens/register_screen.dart';
import '../utils/custom_alert.dart';
import '../utils/custom_dio.dart';

class LoginController {
  BuildContext context;
  final emailTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();

  LoginController(this.context);

  void login() async {
    final email = emailTxtController.text.toString();
    final password = passwordTxtController.text.toString();
    try {
      ///Login on your system backend
      CustomAlert.customLoadingDialog(context: context);
      final d = (await CustomDio().send(
              reqMethod: "post",
              path: "user/login",
              body: {"email": email, "password": password}))
          .data['data'];
      final u = User.fromMap(d);

      await GetStorage().write("myModel", u.toMap());

      ///Login on v_chat_sdk system
      await VChatController.instance
          .login(VChatLoginDto(email: email, password: password));
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Home(),
      ));
    } on VChatSdkException catch (err) {
      Navigator.pop(context);
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }

  void register() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const RegisterScreen(),
    ));
  }
}
