import 'package:get/get.dart';

import '../controllers/my_orders_controller.dart';

class MyOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyOrdersController>(
      MyOrdersController(),
    );
  }
}
