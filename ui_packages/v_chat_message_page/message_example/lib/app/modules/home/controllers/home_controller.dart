import 'package:get/get.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HomeController extends GetxController {
  final VRoom vRoom;
  late final VMessageController msgController;

  HomeController(this.vRoom) {
    msgController = VMessageController(
      vRoom: vRoom,
      onMentionPress: (userId) {},
    );
  }

  @override
  void onClose() {
    super.onClose();
    msgController.dispose();
  }
}
