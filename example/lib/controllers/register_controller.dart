import 'dart:io';
import 'package:example/models/user.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:example/utils/custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textless/textless.dart';
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
      if (imagePath != null) {
        myUser = (await CustomDio().uploadFile(
                apiEndPoint: "user/register",
                filePath: imagePath!,
                body: [
              {"email": email},
              {"password": password},
              {"userName": name},
            ]))
            .data['data'];
      } else {
        myUser = (await CustomDio()
                .send(reqMethod: "post", path: "user/register", body: {
          "email": email,
          "password": password,
          "userName": name,
        }))
            .data['data'];
      }
      final u = User.fromMap(myUser);
      await GetStorage().write("myModel", u.toMap());

      await VChatController.instance.register(
        VChatRegisterDto(
          name: name,
          userImage: imagePath == null ? null : File(imagePath!),
          email: email,
          password: password,
        ),
      );

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Home(),
      ));
    } on VChatSdkException catch (err) {
      //handle vchat exception here
      rethrow;
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }
}
