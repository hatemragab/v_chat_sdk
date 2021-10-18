import 'package:example/generated/l10n.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../models/user.dart';
import 'package:textless/textless.dart';

class UserProfile extends StatefulWidget {
  final User user;

  UserProfile(this.user);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: InkWell(onTap: startChat, child: Text(S.of(context).message)),
        ));
  }

  void startChat() async {
    try {
      await VChatController.instance
          .createSingleChat(ctx: context, peerEmail: widget.user.email);
    } on VChatSdkException catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }
}
