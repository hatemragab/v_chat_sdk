import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/core/clould/cloud_fire_upload.dart';
import 'package:v_chat_sdk_sample/app/core/enums.dart';
import 'package:v_chat_sdk_sample/app/core/models/product.model.dart';
import 'package:v_chat_sdk_sample/app/core/repository/product.repository.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../core/utils/app_auth.dart';

class CreateProductController extends GetxController {
  final ProductRepository repository;
  final user = AppAuth.getMyModel;
  PlatformFileSource? productImage;
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  CreateProductController(this.repository);

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
        VAppAlert.hideLoading();
        Get.back();
      },
      onError: (exception) {
        VAppAlert.hideLoading();
      },
      onLoading: () {
        VAppAlert.showLoading(context: Get.context!);
      },
      request: () async {
        final imgUrl =
            await CloudFireUpload.uploadFile(productImage!, user.uid);
        final product = ProductModel(
          productId: "${DateTime.now().microsecondsSinceEpoch}-${user.uid}",
          price: int.parse(priceController.text),
          userModel: user,
          desc: descController.text,
          createdAt: DateTime.now().toUtc(),
          imageUrl: imgUrl,
          title: nameController.text,
        );
        await repository.add(product);
      },
    );
  }

  void onCameraClick() async {
    final image = await AppPick.getImage();
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
