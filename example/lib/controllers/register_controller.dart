import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../screens/home.dart';
import '../utils/custom_alert.dart';

class RegisterController {
  BuildContext context;
  final emailTxtController = TextEditingController();
  final nameTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();
  bool appTerms = false;
  String? imagePath;

  RegisterController(this.context);

  void register() async {
    final email = emailTxtController.text.toString();
    final name = nameTxtController.text.toString();
    //final password = passwordTxtController.text.toString();

    try {
      CustomAlert.customLoadingDialog(context: context);
      if (!appTerms) {
        throw "accept v chat terms to use the app";
      }

      /// your image validation
      if (imagePath != null) {
        if (File(imagePath!).lengthSync() > 1024 * 1024 * 20) {
          throw "image size must be less than 20 Mb";
        }
      }

      ///First Register on your system backend
      // final d = (await CustomDio().send(
      //         reqMethod: "post",
      //         path: "YOUR SYSTEM APIS / register",
      //         body: {"email": email, "password": password}))
      //     .data['data'];
      // final u = User.fromMap(d);

      /// Then Register on v_chat_sdk system
      final u = await VChatController.instance.register(
        dto: VChatRegisterDto(
          name: name,

          /// if you pass imagePath to null v chat will use the default user image
          /// see here for more info
          /// https://hatemragab.github.io/VChatSdk-Documentation/docs/backend_installation/a_project_settings#update-default-users-image
          userImage: imagePath == null ? null : File(imagePath!),
          email: email,
        ),
        context: context,
      );

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
}
