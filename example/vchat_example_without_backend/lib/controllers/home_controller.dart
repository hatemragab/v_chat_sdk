import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:textless/textless.dart';
import '../models/user.dart';
import 'theme_controller.dart';

class HomeController {
  BuildContext context;
  final emailTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();

  HomeController(this.context);

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

  Future<List<User>> getUsers() async {

    return [];
  }
}
