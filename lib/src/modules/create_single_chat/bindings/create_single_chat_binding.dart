import 'package:get/get.dart';
import '../controllers/create_single_chat_controller.dart';
import '../providers/create_single_chat_provider.dart';

class CreateSingleChatBinding {
  static void bind() {
    Get.put<CreateSingleChatProvider>(
      CreateSingleChatProvider(),
    );

    Get.put<CreateSingleChatController>(
      CreateSingleChatController(),
    );
  }

  static void unBind() {
    Get.delete<CreateSingleChatProvider>(force: true);

    Get.delete<CreateSingleChatController>(force: true);
  }
}
