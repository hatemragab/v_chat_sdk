import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:example/generated/l10n.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:textless/textless.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

/// this is just example you can define your own design
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
              S.of(context).updateImage.text,
              InkWell(
                onTap: () {
                  updateImage();
                },
                child: const Icon(
                  Icons.image,
                  size: 100,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: nameC,
                decoration: InputDecoration(hintText: S.of(context).newName),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: updateName, child: S.of(context).updateName.text),
              const SizedBox(
                height: 10,
              ),
              //ElevatedButton(onPressed: changePassword, child: "update password".text),
            ],
          ),
        ),
      ),
    );
  }

  void updateName() async {
    try {
      if (nameC.text.isEmpty) {
        throw S.of(context).enterTheName;
      }

      ///update your system first
      // await CustomDio()
      //     .send(reqMethod: "patch", path: "YOUR BACKEND/update", body: {"name": nameC.text});
      /// then update v chat so user name will be updated in chats
      await VChatController.instance
          .updateUserName(name: nameC.text.toString());
      nameC.clear();
      CustomAlert.showSuccess(
          context: context, err: S.of(context).yourNameHasBeenUpdated);
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
        if (File(img.path).lengthSync() > 1024 * 1024 * 20) {
          throw S.of(context).imageSizeMustBeLessThan20Mb;
        }
        CustomAlert.customLoadingDialog(context: context);

        ///update to your service first
        // (await CustomDio().uploadFile(
        //   filePath: img.path,
        //
        //   apiEndPoint: "YOUR BACKEND/update",
        // ))
        //     .data['data']
        //     .toString();
        ///then update on v chat
        await VChatController.instance.updateUserImage(imagePath: img.path);
        Navigator.pop(context);
        CustomAlert.showSuccess(
            context: context, err: S.of(context).yourImageHasBeenUpdated);
      }
    } on VChatSdkException catch (err) {
      Navigator.pop(context);
      CustomAlert.showError(context: context, err: err.toString());
      log(err.data.toString());
      rethrow;
      //handle Errors
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.showError(context: context, err: err.toString());
    }
  }
}
