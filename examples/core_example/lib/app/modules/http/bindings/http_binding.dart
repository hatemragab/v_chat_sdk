import 'package:get/get.dart';

import '../controllers/http_controller.dart';

class HttpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HttpController>(
      HttpController(),
    );
  }
}
