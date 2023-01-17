import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../core/utils/app_auth.dart';
import '../../../routes/app_pages.dart';

class CreateGroupController extends GetxController {
  final List<UserModel> users;

  CreateGroupController(this.users);

  final user = AppAuth.getMyModel;
  VPlatformFileSource? groupImage;
  final nameController = TextEditingController();

  void onCameraClick() async {
    final image = await VAppPick.getCroppedImage();
    if (image != null) {
      groupImage = image;
      update();
    }
  }

  void onSave() async {
    final name = nameController.text.toString();
    if (name.isEmpty) {
      VAppAlert.showErrorSnackBar(
          msg: "name must not empty", context: Get.context!);
    }
    if (groupImage == null) {
      VAppAlert.showErrorSnackBar(
          msg: "image must not empty", context: Get.context!);
    }
    await vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: Get.context!);
      },
      request: () async {
        await Future.delayed(const Duration(seconds: 1));

        // V CHAT REQUEST
      },
      onSuccess: (response) {
        Get.back();
        Get.until((route) => route.settings.name == Routes.HOME);
      },
      onError: (exception, trace) {
        Get.back();
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
  }
}
