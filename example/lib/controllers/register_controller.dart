import 'dart:io';
import 'package:example/models/user.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:example/utils/custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../screens/home.dart';

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
    final password = passwordTxtController.text.toString();

    dynamic myUser;

    try {
      CustomAlert.customLoadingDialog(context: context);

      ///Register on your system backend
      if (imagePath != null) {
        if (File(imagePath!).lengthSync() > 1024 * 1024 * 10) {
          throw "image size must be less than 10 Mb";
        }
        myUser = (await CustomDio().uploadFile(
                apiEndPoint: "user/register",
                filePath: imagePath!,
                body: [
              {"email": email},
              {"password": password},
              {"name": name},
            ]))
            .data['data'];
      } else {
        myUser = (await CustomDio()
                .send(reqMethod: "post", path: "user/register", body: {
          "email": email,
          "password": password,
          "name": name,
        }))
            .data['data'];
      }
      final u = User.fromMap(myUser);
      await GetStorage().write("myModel", u.toMap());

      ///Register on v_chat_sdk system
      await VChatController.instance.register(
        VChatRegisterDto(
          name: name,
          userImage: imagePath == null ? null : File(imagePath!),
          email: email,
          password: password,
        ),
      );
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Home(),
      ));
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
