import 'package:get/get.dart';

import '../controllers/create_product_controller.dart';

class CreateProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CreateProductController>(
      CreateProductController( ),
    );
  }
}
