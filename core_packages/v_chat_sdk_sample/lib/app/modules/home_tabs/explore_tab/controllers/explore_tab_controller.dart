import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

class ExploreTabController extends GetxController {
  // final ProductRepository repository;

  // ExploreTabController(this.repository);

  void onCreateProduct() {
    Get.toNamed(Routes.CREATE_PRODUCT);
  }
}
