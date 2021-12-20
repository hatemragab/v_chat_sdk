import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../screens/home.dart';
import '../screens/register_screen.dart';
import '../utils/custom_alert.dart';

class LoginController {
  BuildContext context;
  final emailTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();
  bool appTerms = false;

  LoginController(this.context);

  void login() async {
    final email = emailTxtController.text.toString();
    //final password = passwordTxtController.text.toString();
    try {
      CustomAlert.customLoadingDialog(context: context);
      if (!appTerms) {
        throw "accept v chat terms to use the app";
      }

      ///First Login on your system backend
      ///Once success login then start login to v chat sdk
      // final d = (await CustomDio().send(
      //         reqMethod: "post",
      //         path: "YOUR SYSTEM APIS /LOGIN",
      //         body: {"email": email, "password": password}))
      //     .data['data'];
      // final u = User.fromMap(d);

      ///Login on v_chat_sdk system
      ///please note if your app already in production you need to see how to migrate old users from
      ///https://hatemragab.github.io/VChatSdk-Documentation/docs/backend_installation/z_migrate_old_users
      final u =
          await VChatController.instance.login(context: context, email: email);

      ///save user in example app you can save your user by your way
      await GetStorage().write("myModel", u.toMap());
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false);
    } on VChatSdkException catch (err) {
      ///catch v chat sdk exception may be no user found in v chat
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
