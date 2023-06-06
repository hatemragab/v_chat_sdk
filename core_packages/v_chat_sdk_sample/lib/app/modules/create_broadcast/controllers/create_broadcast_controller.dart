// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../routes/app_pages.dart';
import '../../../v_chat/app_pick.dart';
import '../../../v_chat/v_app_alert.dart';
import '../../../v_chat/v_safe_api_call.dart';

class CreateBroadcastController extends GetxController {
  final List<VIdentifierUser> users;

  CreateBroadcastController(
    this.users,
  );

  VPlatformFile? groupImage;
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
      return;
    }
    await vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: Get.context!);
      },
      request: () async {
        await VChatController.I.nativeApi.remote.room.createBroadcast(
          CreateBroadcastDto(
            identifiers: users.map((e) => e.identifier).toList(),
            title: name,
            platformImage: groupImage,
          ),
        );
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
