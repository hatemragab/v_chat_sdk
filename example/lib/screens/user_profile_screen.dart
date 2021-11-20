import 'package:example/utils/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import 'package:textless/textless.dart';
import '../models/user.dart';

class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile(this.user, {Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: "${widget.user.name} ".text,
      ),
      body: Center(
        child: InkWell(
            onTap: startChat,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.messenger,
                  size: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                "message".text,
              ],
            )),
      ),
    );
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
