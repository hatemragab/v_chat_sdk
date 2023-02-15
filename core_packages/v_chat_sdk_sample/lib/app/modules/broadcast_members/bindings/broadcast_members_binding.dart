import 'package:get/get.dart';

import '../controllers/broadcast_members_controller.dart';

class BroadcastMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BroadcastMembersController>(
      BroadcastMembersController(Get.arguments),
    );
  }
}
