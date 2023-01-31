import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

class GroupSettingsController extends GetxController {
  final VToChatSettingsModel data;

  GroupSettingsController(this.data);

  void toShowMembers() {
    Get.toNamed(Routes.GROUP_MEMBERS, arguments: data);
  }
}
