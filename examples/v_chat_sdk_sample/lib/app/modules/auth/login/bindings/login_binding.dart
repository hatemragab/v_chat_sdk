import 'package:get/get.dart';

import '../../../../core/repository/user.repository.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(Get.find<UserRepository>()),
    );
  }
}
