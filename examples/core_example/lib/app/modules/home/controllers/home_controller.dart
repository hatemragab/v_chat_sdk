import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HomeController extends GetxController {
  void loginTest() async {
    final loginRes = await VChatController.instance.login(VChatLoginDto());
    print(loginRes);
  }
}
