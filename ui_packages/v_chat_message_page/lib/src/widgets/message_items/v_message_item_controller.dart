import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VMessageItemController {
  void onMessageItemPress(VBaseMessage message) {}

  void onMessageItemLongPress(VBaseMessage message) {}

  Future onLinkPress(String link) async {
    await VStringUtils.lunchLink(link);
  }

  Future onEmailPress(String email) async {
    await VStringUtils.lunchLink(email);
  }

  Future onPhonePress(String phone) async {
    await VStringUtils.lunchLink(phone);
  }
}
