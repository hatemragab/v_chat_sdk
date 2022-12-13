import 'package:get/get.dart';

import '../controllers/message_input_controller.dart';

class MessageInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MessageInputController>(
      MessageInputController(),
    );
  }
}
