import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:textless/textless.dart';
import '../vchat_package/app/dto/vchat_register_dto.dart';
import '../vchat_package/vchat_controller.dart';
import '../models/user.dart';
import '../screens/home.dart';

class RegisterController {
  BuildContext context;
  final emailTxtController = TextEditingController();
  final nameTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();

  String? imagePath;

  RegisterController(this.context) {
    emailTxtController.text = "1@gmail.com";
    nameTxtController.text = "nammmmmme";
    passwordTxtController.text = "passssssssssss";
  }

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

  void register() async {
    final email = emailTxtController.text.toString();
    final name = nameTxtController.text.toString();
    final password = passwordTxtController.text.toString();
    try {
      final vChatUser = await VChatController.instance.register(
        VchatRegisterDto(
          name: name,
          userImage: imagePath == null ? null : File(imagePath!),
          email: email,
          password: password,
        ),
      );
      await GetStorage().write("myModel", vChatUser.toMap());
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Home(),
      ));
    } catch (err) {
      showDialog1(err.toString());
      rethrow;
    }
  }
}
