import 'package:example/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../models/user.dart';
import '../utils/custom_alert.dart';
import '../utils/custom_dio.dart';

class HomeController {
  BuildContext context;

  HomeController(this.context);

  Future<List<User>> getUsers() async {
    try {
      final res = (await CustomDio()
              .send(reqMethod: "get", path: "user", query: {"lastId": "first"}))
          .data['data'] as List;
      return res.map((e) => User.fromMap(e)).toList();
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }

  void startChat(String email) async {
    try {
      final res =
          await CustomAlert.chatAlert(context: context, peerEmail: email);
      if (res != null) {
        await VChatController.instance
            .createSingleChat(peerEmail: email, message: res);
        CustomAlert.done(
          msg: S.of(context).success,
        );
      }
    } on VChatSdkException catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }
}
