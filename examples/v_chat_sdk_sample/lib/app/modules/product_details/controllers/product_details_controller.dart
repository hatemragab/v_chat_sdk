import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/models/order.model.dart';
import 'package:v_chat_sdk_sample/app/core/models/product.model.dart';
import 'package:v_chat_sdk_sample/app/core/repository/order.repository.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_alert.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_auth.dart';
import 'package:v_chat_sdk_sample/app/core/utils/async_ui_notifier.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

class ProductDetailsController extends GetxController {
  final ProductModel productModel;
  final OrderRepository orderRepository;

  ProductDetailsController(this.productModel, this.orderRepository);

  void startChat() async {
    final res = await AppAlert.showAskYesNoDialog(
      title: "Start v chat sdk product chat",
      content:
          "by click yes the product chat will created and product data will pinned in the unique product chat",
    );
    if (res == 1) {}
  }

  void startAddOrder() async {
    final res = await AppAlert.showAskYesNoDialog(
      title: "Add fake order",
      content:
          "This fake order to show how to start chat with delivery person after adding the order you can start chat with the delivery about the order",
    );
    if (res == 1) {
      safeApiCall(
        onLoading: () {
          AppAlert.showLoading();
        },
        request: () async {
          return await orderRepository.add(OrderModel(
            id: "${DateTime.now().microsecondsSinceEpoch}",
            productModel: productModel,
            userId: AppAuth.getMyModel.uid,
            createdAt: DateTime.now().toUtc(),
          ));
        },
        onSuccess: (response) {
          AppAlert.hideLoading();
          Get.toNamed(Routes.MY_ORDERS);
        },
      );
    }
  }
}
