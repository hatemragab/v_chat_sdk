import 'package:example/utils/custom_alert.dart';
import 'package:example/utils/custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class HomeController {
  BuildContext context;

  HomeController(this.context);

  Future<List<User>> getUsers() async {
    try {
      final res = (await CustomDio().send(
        reqMethod: "get",
        path: "user/all",
      ))
          .data['data'] as List;
      return res.map((e) => User.fromMap(e)).toList();
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }
}
