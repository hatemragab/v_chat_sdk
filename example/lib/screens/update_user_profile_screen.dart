import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:example/generated/l10n.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:example/utils/custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:textless/textless.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  const UpdateUserProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateUserProfileScreenState createState() => _UpdateUserProfileScreenState();
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
              InkWell(
                onTap: () {
                  updateImage();
                },
                child: const Icon(
                  Icons.image,
                  size: 100,
                ),
              ),
              const Divider(),
              CupertinoTextField(
                controller: nameC,
                placeholder: "new name",
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: updateName, child: "update name".text),
              const Divider(),
              CupertinoTextField(
                placeholder: "old Pass ",
                controller: oldPassC,
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                placeholder: "new Pass ",
                controller: newPassC,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: changePassword, child: "update password".text),
            ],
          ),
        ),
      ),
    );
  }

  void updateName() async {
    try {
      if (nameC.text.isEmpty) {
        throw "Enter the name";
      }
      await CustomDio().send(reqMethod: "patch", path: "user", body: {"name": nameC.text});
      await VChatController.instance.updateUserName(name: nameC.text.toString());
      nameC.clear();
      CustomAlert.showSuccess(context: context, err: "your name has been updated !");
    } on VChatSdkException catch (err) {
      //handle Errors
      log(err.data.toString());
      rethrow;
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
    }
  }

  void changePassword() async {
    try {
      if (oldPassC.text.isEmpty) {
        throw "Enter the old password";
      }
      if (newPassC.text.isEmpty) {
        throw "Enter the new password";
      }
      await CustomDio()
          .send(reqMethod: "patch", path: "user", body: {"oldPassword": oldPassC.text, "newPassword": newPassC.text});

      await VChatController.instance.updateUserPassword(newPassword: newPassC.text, oldPassword: oldPassC.text);
      CustomAlert.showSuccess(context: context, err: "your password has been updated !");
      oldPassC.clear();
      newPassC.clear();
    } on VChatSdkException catch (err) {
      //handle Errors
      log(err.data.toString());
      rethrow;
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
    }
  }

  void updateImage() async {
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.gallery);
      if (img != null) {
        if (File(img.path).lengthSync() > 1024 * 1024 * 10) {
          throw "image size must be less than 10 Mb";
        }
        (await CustomDio().uploadFile(
          filePath: img.path,
          isPost: false,
          apiEndPoint: "user",
        ))
            .data['data']
            .toString();
        await VChatController.instance.updateUserImage(imagePath: img.path);
        CustomAlert.showSuccess(context: context, err: "your image has been updated !");
      }
    } on VChatSdkException catch (err) {
      log(err.data.toString());
      rethrow;
      //handle Errors
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
    }
  }
}
