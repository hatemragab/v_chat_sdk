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

  LoginController(this.context);

  void login() async {
    final email = emailTxtController.text.toString();
    //final password = passwordTxtController.text.toString();
    try {
      CustomAlert.customLoadingDialog(context: context);

      ///Login on your system backend
      // final d = (await CustomDio().send(
      //         reqMethod: "post",
      //         path: "user/login",
      //         body: {"email": email, "password": password}))
      //     .data['data'];
      // final u = User.fromMap(d);

      ///Login on v_chat_sdk system
      final u =
          await VChatController.instance.login(context: context, email: email);
      await GetStorage().write("myModel", u.toMap());
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false);
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
