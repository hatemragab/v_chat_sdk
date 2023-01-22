import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/models/order.model.dart';
import 'package:v_chat_sdk_sample/app/core/models/product.model.dart';
import 'package:v_chat_sdk_sample/app/core/repository/order.repository.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_auth.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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
