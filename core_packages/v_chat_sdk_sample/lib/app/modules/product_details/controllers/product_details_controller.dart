// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

import '../../../v_chat/v_app_alert.dart';

class ProductDetailsController extends GetxController {
  // final ProductModel productModel;
  // final OrderRepository orderRepository;

  // ProductDetailsController(this.productModel, this.orderRepository);

  void startChat() async {
    final res = await VAppAlert.showAskYesNoDialog(
      title: "Start v chat sdk product chat",
      context: Get.context!,
      content:
          "by click yes the product chat will created and product data will pinned in the unique product chat",
    );
    if (res == 1) {}
  }

  void startAddOrder() async {
    final res = await VAppAlert.showAskYesNoDialog(
      title: "Add fake order",
      context: Get.context!,
      content:
          "This fake order to show how to start chat with delivery person after adding the order you can start chat with the delivery about the order",
    );
    if (res == 1) {
      vSafeApiCall(
        onLoading: () {
          VAppAlert.showLoading(context: Get.context!);
        },
        request: () async {
          // return await orderRepository.add(OrderModel(
          //   id: "${DateTime.now().microsecondsSinceEpoch}",
          //   productModel: productModel,
          //   userId: AppAuth.getMyModel.id,
          //   createdAt: DateTime.now().toUtc(),
          // ));
        },
        onSuccess: (response) {
          Get.back();
          Get.toNamed(Routes.MY_ORDERS);
        },
      );
    }
  }
}
