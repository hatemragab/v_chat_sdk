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
          child: InkWell(onTap: startChat, child: Text("Message")),
        ));
  }

  void startChat() async {
    try {
      await VChatController.instance
          .createSingleChat(ctx: context, peerEmail: widget.user.email);
    } catch (err) {
      showDialog1(err.toString());
      rethrow;
    }
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
}
