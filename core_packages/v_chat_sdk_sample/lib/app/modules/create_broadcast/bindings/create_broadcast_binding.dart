import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../controllers/create_broadcast_controller.dart';

class CreateBroadcastBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CreateBroadcastController>(
      CreateBroadcastController(Get.arguments as List<VIdentifierUser>),
    );
  }
}
