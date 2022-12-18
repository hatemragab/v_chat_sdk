import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/core/clould/cloud_fire_upload.dart';
import 'package:v_chat_sdk_sample/app/core/enums.dart';
import 'package:v_chat_sdk_sample/app/core/repository/user.repository.dart';
 import 'package:v_chat_sdk_sample/app/core/utils/app_auth.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

 import '../../auth/authenticate.dart';

class EditProfileController extends GetxController {
  final user = AppAuth.getMyModel;
  late PlatformFileSource userImage;
  final nameController = TextEditingController();
  final UserRepository repository;

  EditProfileController(this.repository);

  @override
  void onInit() {
    userImage = user.imgAsPlatformSource;
    nameController.text = user.userName;
    super.onInit();
  }

  void onCameraClick() async {
    final image = await AppPick.getCroppedImage();
    if (image != null) {
      userImage = image;
      AuthRepo.isAuth.refresh();
    }
  }

  void onSave() async {
    VAppAlert.showLoading(context: Get.context!);
    final name = nameController.text.toString();
    user.userName = name;
    if (userImage.isNotUrl) {
      //upload image
      user.imageUrl = await CloudFireUpload.uploadFile(userImage, user.uid);
    }
    await repository.edit(user.toMap(), user.uid);
    await AppPref.setMap(StorageKeys.myProfile, user.toMap());
    VAppAlert.hideLoading( );
    AuthRepo.isAuth.refresh();
    VAppAlert.showSuccessSnackBar(msg: "Update successfully",context: Get.context!);
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
  }
}
