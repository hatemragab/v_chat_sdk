import 'package:flutter/material.dart';
import 'package:vchat_test_3/vchat_package/vchat_controller.dart';
import '../models/user.dart';

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
      rethrow;
    }
  }
}
