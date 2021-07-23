import 'package:get/get.dart';
import '../controllers/message_controller.dart';
import '../controllers/send_message_controller.dart';
import '../providers/message_provider.dart';

class MessageBinding {
  static void bind() {
    Get.put<MessageProvider>(
      MessageProvider(),
    );

    Get.put<MessageController>(
      MessageController(),
    );
    Get.put<SendMessageController>(
      SendMessageController(),
    );
  }

  static void unBind() {
    Get.delete<MessageProvider>(force: true);
    Get.delete<MessageController>(force: true);
    Get.delete<SendMessageController>(force: true);
  }
}
