import 'dart:io';

import 'package:example/generated/l10n.dart';
import 'package:example/models/user.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../home.dart';

/// please Note this is example you can have your own design
class CreateGroupController extends ChangeNotifier {
  final BuildContext context;
  final List<User> users;
  final textEditingController = TextEditingController();
  String? imagePath;

  CreateGroupController({
    required this.context,
    required this.users,
  });

  void createGroup() async {
    try {
      CustomAlert.customLoadingDialog(context: context);
      if (textEditingController.text.isEmpty) {
        throw S.of(context).enterTitle;
      }
      if (imagePath == null) {
        throw S.of(context).chooseGroupImage;
      }
      await VChatController.instance.createGroupChat(
        context: context,
        createGroupRoomDto: CreateGroupRoomDto(
          groupImage: File(imagePath!),
          groupTitle: textEditingController.text,
          usersEmails: users.map((e) => e.email).toList(),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false);
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.showError(context: context, err: err.toString());
    }
  }

  void pickGroupImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      if (File(img.path).lengthSync() > 1024 * 1024 * 20) {
        CustomAlert.showError(
            context: context, err: S.of(context).imageSizeMustBeLessThan20Mb);
        throw S.of(context).imageSizeMustBeLessThan20Mb;
      }
      imagePath = img.path;
      CustomAlert.done(msg: S.of(context).imageHasBeenSelected);
    }
    notifyListeners();
  }
}
