import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/models/product.model.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductDetailsController>(
      ProductDetailsController(Get.arguments as ProductModel, Get.find()),
    );
  }
}