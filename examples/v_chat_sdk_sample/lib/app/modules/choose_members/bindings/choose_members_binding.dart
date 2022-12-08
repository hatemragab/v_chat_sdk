import 'package:get/get.dart';

import '../controllers/choose_members_controller.dart';

class ChooseMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChooseMembersController>(
      ChooseMembersController(),
    );
  }
}
