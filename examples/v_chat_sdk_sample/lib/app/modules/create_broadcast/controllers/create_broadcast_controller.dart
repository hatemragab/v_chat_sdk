import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_sdk_sample/app/core/utils/async_ui_notifier.dart';

import '../../../core/utils/app_alert.dart';
import '../../../core/utils/app_auth.dart';
import '../../../core/utils/app_pick.dart';
import '../../../routes/app_pages.dart';

class CreateBroadcastController extends GetxController {
  final List<UserModel> users;

  CreateBroadcastController(this.users);

  final user = AppAuth.getMyModel;
  PlatformFileSource? groupImage;
  final nameController = TextEditingController();

  void onCameraClick() async {
    final image = await AppPick.getCroppedImage();
    if (image != null) {
      groupImage = image;
      update();
    }
  }

  void onSave() async {
    final name = nameController.text.toString();
    if (name.isEmpty) {
      AppAlert.showErrorSnackBar(msg: "name must not empty");
    }
    if (groupImage == null) {
      AppAlert.showErrorSnackBar(msg: "image must not empty");
    }
    await safeApiCall(
      onLoading: () {
        AppAlert.showLoading();
      },
      request: () async {
        await Future.delayed(const Duration(seconds: 1));
        // V CHAT REQUEST
      },
      onSuccess: (response) {
        AppAlert.hideLoading();
        Get.until((route) => route.settings.name == Routes.HOME);
      },
      onError: (exception) {
        AppAlert.hideLoading();
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
  }
}
