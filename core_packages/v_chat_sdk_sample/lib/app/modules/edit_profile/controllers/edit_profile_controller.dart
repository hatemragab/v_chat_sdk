import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_auth.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class EditProfileController extends GetxController {
  final user = AppAuth.getMyModel;
  late VPlatformFileSource userImage;
  final nameController = TextEditingController();
  // final UserRepository repository;

  // EditProfileController(this.repository);

  @override
  void onInit() {
    userImage = user.imgAsPlatformSource;
    nameController.text = user.userName;
    super.onInit();
  }

  void onCameraClick() async {
    final image = await VAppPick.getCroppedImage();
    if (image != null) {
      userImage = image;
    }
  }

  void onSave() async {
    VAppAlert.showLoading(context: Get.context!);
    final name = nameController.text.toString();
    user.userName = name;
    // await repository.edit(user.toMap(), user.id);
    await VAppPref.setMap(VStorageKeys.vMyProfile.name, user.toMap());
    Get.back();
    VAppAlert.showSuccessSnackBar(
        msg: "Update successfully", context: Get.context!);
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
  }
}
