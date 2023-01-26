import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/models/user.model.dart';
import '../controllers/create_group_controller.dart';

class CreateGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CreateGroupController>(
      CreateGroupController(Get.arguments as List<VIdentifierUser>),
    );
  }
}
