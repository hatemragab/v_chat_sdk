import 'package:get/get.dart';

import '../controllers/message_ui_controller.dart';

class MessageUiBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MessageUiController>(
      MessageUiController(),
    );
  }
}
