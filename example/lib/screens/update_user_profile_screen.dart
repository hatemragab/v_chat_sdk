import 'package:example/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:textless/textless.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  const UpdateUserProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateUserProfileScreenState createState() =>
      _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
  final nameC = TextEditingController();
  final oldPassC = TextEditingController();
  final newPassC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: S.of(context).update.text,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              "update image ".text,
              Icon(
                Icons.image,
                size: 100,
              ),
              Divider(),
              CupertinoTextField(
                controller: nameC,
                placeholder: "new name",
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: updateName, child: "update name".text),
              Divider(),
              CupertinoTextField(
                placeholder: "old Pass ",
                controller: oldPassC,
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                placeholder: "new Pass ",
                controller: newPassC,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: updateName, child: "update password".text),
            ],
          ),
        ),
      ),
    );
  }

  void updateName() async {
    try {
      await VChatController.instance.updateUserName(name: "new name");
    } on VChatSdkException catch (err) {
      //handle Errors
    }
  }

  void changePassword() async {
    try {
      await VChatController.instance
          .updateUserPassword(newPassword: "new", oldPassword: "old");
    } on VChatSdkException catch (err) {
      //handle Errors
    }
  }

  void updateImage() async {
    try {
      await VChatController.instance.logOut();
      await VChatController.instance.updateUserImage(imagePath: "file.path!");
    } on VChatSdkException catch (err) {
      //handle Errors
    }
  }
}
