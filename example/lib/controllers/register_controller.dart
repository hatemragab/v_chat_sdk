import 'dart:io';
import 'package:flutter/cupertino.dart';
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

  String? imagePath;

  RegisterController(this.context);

  void register() async {
    final email = emailTxtController.text.toString();
    final name = nameTxtController.text.toString();
    //final password = passwordTxtController.text.toString();

    try {
      CustomAlert.customLoadingDialog(context: context);

      ///Register on your system backend
      if (imagePath != null) {
        if (File(imagePath!).lengthSync() > 1024 * 1024 * 20) {
          throw "image size must be less than 20 Mb";
        }
      }

      ///first register on your system

      ///then Register on v_chat_sdk system
      final u = await VChatController.instance.register(
        dto: VChatRegisterDto(
            name: name,
            userImage: imagePath == null ? null : File(imagePath!),
            email: email),
        context: context,
      );
      await GetStorage().write("myModel", u.toMap());
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false);
    } on VChatSdkException catch (err) {
      Navigator.pop(context);
      CustomAlert.showError(context: context, err: err.toString());
      //handle vchat exception here
      rethrow;
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }
}
