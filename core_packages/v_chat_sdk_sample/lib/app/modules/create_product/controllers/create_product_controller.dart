// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_platform/v_platform.dart';

import '../../../core/utils/app_auth.dart';

class CreateProductController extends GetxController {
  // final ProductRepository repository;
  final user = AppAuth.getMyModel;
  VPlatformFile? productImage;
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  // CreateProductController(this.repository);

  Future create() async {
    if (nameController.text.isEmpty) {
      VAppAlert.showErrorSnackBar(
          msg: "title should not empty", context: Get.context!);
      return;
    }
    if (descController.text.isEmpty) {
      VAppAlert.showErrorSnackBar(
          msg: "description should not empty", context: Get.context!);
      return;
    }
    if (priceController.text.isEmpty) {
      VAppAlert.showErrorSnackBar(
          msg: "price should not empty", context: Get.context!);
      return;
    }
    if (productImage == null) {
      VAppAlert.showErrorSnackBar(
          msg: "image should not empty", context: Get.context!);
      return;
    }
    await vSafeApiCall(
      onSuccess: (response) {
        Get.back();
        Get.back();
      },
      onError: (exception, trace) {
        Get.back();
      },
      onLoading: () {
        VAppAlert.showLoading(context: Get.context!);
      },
      request: () async {
        // final imgUrl = await CloudFireUpload.uploadFile(productImage!, user.id);
        // final product = ProductModel(
        //   productId: "${DateTime.now().microsecondsSinceEpoch}-${user.id}",
        //   price: int.parse(priceController.text),
        //   userModel: user,
        //   desc: descController.text,
        //   createdAt: DateTime.now().toUtc(),
        //   imageUrl: imgUrl,
        //   title: nameController.text,
        // );
        // await repository.add(product);
      },
    );
  }

  void onCameraClick() async {
    final image = await VAppPick.getImage();
    if (image != null) {
      productImage = image;
      update();
    }
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    priceController.dispose();
  }
}
