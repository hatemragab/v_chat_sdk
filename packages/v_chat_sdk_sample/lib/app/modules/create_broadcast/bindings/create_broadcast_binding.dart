import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';

import '../controllers/create_broadcast_controller.dart';

class CreateBroadcastBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CreateBroadcastController>(
      CreateBroadcastController(Get.arguments as List<UserModel>),
    );
  }
}
